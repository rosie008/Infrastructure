module "networking" {
  source = "../modules/networking"

  project_name = "rose-experimental"

  vpc_cidr_block = "10.1.0.0/16"

}

module "ssm_role" {
  source = "../modules/iam/ssm-role"
  project_name = "rose-experimental"
}

module "bastion-host" {
  source = "../modules/bastion"

  key-pair = "C:/Users/USER/Documents/rose/project/key/id_rsa.pub"
  project_name = "rose-experimental"
  vpc_id = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_id
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
  instance_type = "t3.micro"
  iam_instance_profile = module.ssm_role.iam_instance_profile
}