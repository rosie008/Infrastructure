module "networking" {
  source = "../modules/networking"

  project_name = "rose-experimental"

  vpc_cidr_block = "10.1.0.0/16"

}

module "ssm_role" {
  source = "../modules/iam/ssm-role"
  project_name = "rose-experimental"
}

module "ami" {
  source = "../modules/ami"
  filter_name = "ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-*"
}

module "bastion-host" {
  source = "../modules/bastion"

  key-pair = "C:/Users/USER/Documents/rose/project/key/id_rsa.pub"
  project_name = "rose-experimental"
  vpc_id = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_id
  ami_id = module.ami.ami_id
  instance_type = "t3.micro"
  iam_instance_profile = module.ssm_role.iam_instance_profile
}


module "lb" {
  source = "../modules/lb"

  backend_1 = module.bastion-host.public_ip
  backend_2 = module.bastion-host.public_ip
  project_name = "rose-experimental"
  vpc_id = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_id
  ami_id = module.ami.ami_id
  instance_type = "t3.micro"
  iam_instance_profile = module.ssm_role.iam_instance_profile
}

module "k8s-master" {
  source = "../modules/k8s-master"

  project_name = "rose-experimental"
  vpc_id = module.networking.vpc_id
  subnet_id = module.networking.private_subnet_id
  private_subnet_cidr = module.networking.private_subnet_cidr
  ami_id = module.ami.ami_id
  instance_type = "t3.medium"
  iam_instance_profile = module.ssm_role.iam_instance_profile
}

module "k8s-worker" {
  source = "../modules/k8s-worker"

  project_name = "rose-experimental"
  vpc_id = module.networking.vpc_id
  subnet_id = module.networking.private_subnet_id
  private_subnet_cidr = module.networking.private_subnet_cidr
  ami_id = module.ami.ami_id
  instance_type = "t3.medium"
  iam_instance_profile = module.ssm_role.iam_instance_profile
}