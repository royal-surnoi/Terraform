module "vpc" {
  source = "../../modules/VPC"
  cidr_block = var.cidr_block
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags
  cidr_public = var.cidr_public
  cidr_private = var.cidr_private
  cidr_database = var.cidr_database
}