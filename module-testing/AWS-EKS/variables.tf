variable "vpc_id" {
  description = "VPC ID"
  default = "vpc-03fc9347fd695b5b2"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  default  = ["subnet-0cb347993ea809cd7","subnet-0d09dc20c374f5989"]
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
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      node_group_name = "fusioniq-dev-node"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 2
      }
    }
  }
}

variable "common_tags" {
  default = {
    project_name = "fusioniq"
    environment = "dev"
    terraform = true
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
