#!/bin/bash
set -eux

# Hostname
hostnamectl set-hostname k8s-master

# Update system
apt-get update -y
apt-get upgrade -y

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Kernel modules
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Sysctl params
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# Install dependencies
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gpg

# Install containerd
apt-get install -y containerd

mkdir -p /etc/containerd

containerd config default | tee /etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# Kubernetes repo
mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' \
  | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update -y

# Install kube tools
apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet

# Initialize cluster
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-cert-extra-sans=$PUBLIC_IP

# Kube config for ubuntu user
mkdir -p /home/ubuntu/.kube

cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config

chown ubuntu:ubuntu /home/ubuntu/.kube/config


# Kube config for ssm user
mkdir -p ~/.kube

sudo cp /etc/kubernetes/admin.conf ~/.kube/config

sudo chown $(id -u):$(id -g) ~/.kube/config

# Install Flannel CNI
su - ubuntu -c "kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml"

# Generate join command
kubeadm token create --print-join-command > /join.sh

chmod +x /join.sh