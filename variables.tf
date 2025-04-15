variable "region" {
  default = "us-east-1"
}

# VPC variables
variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
  default = {
    project_name = "fusioniq"
    terraform    = true
  }
}

variable "project_name" {
  default = "fusioniq"
}
variable "environment" {
  default = "dev"
}

variable "vpc_tags" {
  default = {}
}
variable "igt_tags" {
  default = {}
}

variable "cidr_public" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidr_private" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "cidr_database" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

# Bastion variables 
variable "ami" {
  default = "ami-01816d07b1128cd2d"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_tags" {
  default = {
    Name         = "bastion"
    project_name = "fusioniq"
    terraform    = true
  }
}

# key-pair
variable "key_pair" {
  default = ""
}

# secuity_group-variables
variable "security_group_name" {
  default = "bastion"
}

variable "security_group_description" {
  default = "Allowing SSH,HTTP and all traffic"
}


variable "security_group_tags" {
  default = {}
}

variable "security_group_ingress" {
  default = {
    key1 = { # must  
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 22
      ip_protocol = "tcp"
      to_port     = 22
    }
    key2 = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
    }
    key3 = { # make sure all traffic is required
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }
}

variable "security_group_egress_config" {
  default = {
    egress_rule1 = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }
}

# Amazon RDS
variable "rds_parameter_grp_name" {
  default = "rds-parameter-group"
}

variable "db_security_group_name" {
  default = "database"
}

variable "db_security_group_description" {
  default = "Allowing mysql port"
}

variable "db_tags" {
  default = {}
}

variable "db_security_group_ingress" {
  default = {
    key1 = { # must  
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 3306
      ip_protocol = "tcp"
      to_port     = 3306
    }
  }
}

variable "db_security_group_egress_config" {
  default = {
    egress_rule1 = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }
}

variable "allocated_storage" {
  default = 20
}

variable "storage_type" {
  default = "gp2"
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "8.0.41"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "identifier" {
  default = "fusion"
}
variable "db_name" {
  default = "dev"
}

variable "username" {
  default = "admin"
}

variable "manage_master_user_password" {
  default = true
}

variable "publicly_accessible" {
  default = false # make sure
}

variable "skip_final_snapshot" {
  default = true
}

variable "performance_insights_enabled" {
  default = true
}

# AWS EKS 
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
      capacity_type   = "SPOT"
      node_group_name = "fusioniq-dev-node"
      scaling_config = {
        desired_size = 1
        max_size     = 4
        min_size     = 1
      }
    }
  }
}

variable "cluster_tags" {
  default = {}
}

variable "node_groups_tags" {
  default = {}
}

variable "alb_ingress_version" {
  default = "1.4.8"
}

variable "alb_ingress_image_tag" {
  default = "v2.10.1"
}

# Route53
variable "domain_name" {
  type    = string
  default = "royalreddy.site" # change with project domain currently using personal
}

variable "record_cname_type" {
  type    = string
  default = "CNAME"
}

variable "record_a_type" {
  type    = string
  default = "A"
}

variable "ttl" {
  type    = number
  default = 60
}
