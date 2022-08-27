module "vpc" {
  source = "../Modules/vpc"
}

module "ec2" {
  source                 = "../Modules/ec2"
  instance_type          = var.instance_type
  subnet_id              = module.vpc.subnet_id
  ec2_security_group_ids = module.vpc.ec2_security_group_ids
}
