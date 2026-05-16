module "networking" {
  source = "/modules/networking"

  project_name = "rose-experimental"

  vpc_cidr_block = "10.1.0.0/16"

  
}