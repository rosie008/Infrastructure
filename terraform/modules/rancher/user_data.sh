#!/bin/bash
set -eux

# =========================================================
# Rancher Server Provisioning Script
# OS    : Ubuntu 22.04
# Usage : EC2 user_data.sh
# =========================================================

# Hostname
hostnamectl set-hostname rancher

# Update packages
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y \
    curl \
    wget \
    git \
    vim \
    htop \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https

# =========================================================
# Install Docker
# =========================================================

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

systemctl enable docker
systemctl start docker

# Allow ubuntu user to use docker
usermod -aG docker ubuntu || true

# =========================================================
# Kernel & sysctl tuning
# =========================================================

cat <<EOF | tee /etc/sysctl.d/99-rancher.conf
net.ipv4.ip_forward=1
vm.max_map_count=262144
EOF

sysctl --system

# =========================================================
# Create Rancher data directory
# =========================================================

mkdir -p /opt/rancher

# =========================================================
# Run Rancher Server
# =========================================================

docker run -d \
  --restart=unless-stopped \
  -p 80:80 \
  -p 443:443 \
  --name rancher \
  --privileged \
  -v /opt/rancher:/var/lib/rancher \
  rancher/rancher:stable

# =========================================================
# Finished
# =========================================================

echo "Rancher installation completed."