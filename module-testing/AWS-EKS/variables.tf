variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-0dc29bd71089240a6"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  default     = ["subnet-0ed5b7da269455232", "subnet-0999566daac033cc5"]
}


variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "node_groups" {
  description = "EKS node group configuration"
  default = {
    general = {
      instance_types  = ["t3.medium"]
      capacity_type   = "ON_DEMAND"
      node_group_name = "fusioniq-dev-node"
      scaling_config = {
        desired_size = 1
        max_size     = 5
        min_size     = 1
      }
    }
  }
}

variable "common_tags" {
  default = {
    project_name = "fusioniq"
    environment  = "dev"
    terraform    = true
  }
}

variable "cluster_tags" {
  default = {}
}

variable "node_groups_tags" {
  default = {}
}

variable "project_name" {
  default = "fusioniq"
}
variable "environment" {
  default = "dev"
}
