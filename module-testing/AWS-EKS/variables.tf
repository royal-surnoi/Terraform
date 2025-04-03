variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-04811e718d98ab14f"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  default     = ["subnet-0b2ada4cfcc744c81", "subnet-07b77bea8fd390ba4"]
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
      instance_types  = ["t2.medium"]
      capacity_type   = "ON_DEMAND"
      node_group_name = "fusioniq-dev-node"
      scaling_config = {
        desired_size = 2
        max_size     = 5
        min_size     = 2
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
