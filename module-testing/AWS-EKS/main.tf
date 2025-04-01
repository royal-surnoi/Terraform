module "eks" {
  source = "../../modules/AWS-EKS"

  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  node_groups     = var.node_groups

  project_name     = var.project_name
  environment      = var.environment
  common_tags      = var.common_tags
  cluster_tags     = var.cluster_tags
  node_groups_tags = var.node_groups_tags
}

