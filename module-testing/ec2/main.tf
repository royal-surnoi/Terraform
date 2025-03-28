module "ec2_instance" {
  source = "../../modules/ec2"
  ec2_config = {
    ami = var.ami
    instance_type = var.instance_type
    key_name = module.key_pair.key_name
    vpc_security_group_ids = [module.security_group.security_group_id]
    subnet_id = var.subnet_id
    tags = var.ec2_tags
  }
}

module "key_pair" {
  source = "../../modules/key-pair"
  key_pair_name = "${var.ec2_tags.Name}.pem"
}

module "security_group" {
  source = "../../modules/security-group"
  vpc_id = var.vpc_id
  security_group_config = {
    name = var.security_group_name
    description = var.security_group_description
    tags = var.security_group_tags
  }
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  security_group_ingress_config = var.security_group_ingress

  security_group_egress_config = var.security_group_egress_config
}