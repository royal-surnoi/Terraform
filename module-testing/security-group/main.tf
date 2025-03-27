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