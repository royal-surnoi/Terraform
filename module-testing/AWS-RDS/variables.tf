variable "vpc_id" {
  default = "vpc-04811e718d98ab14f"
}

variable "subnet_ids" {
  type = list(string)
  default = ["subnet-0b2ada4cfcc744c81","subnet-07b77bea8fd390ba4"]
}

variable "security_group_description" {
  default = "Allowing mysql port"
}

variable "security_group_tags" {
  default = {}
}

variable "db_tags" {
  default = {}
}

variable "project_name" {
  default = "fusioniq"  
}
variable "environment" {
  default = "dev"
}


variable "security_group_ingress" {
  default = {
    key1 = { # must  
        cidr_ipv4         = "0.0.0.0/0"
        from_port         = 3306
        ip_protocol       = "tcp"
        to_port           = 3306
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
  default = "prod"
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

variable "common_tags" {
  default = {
    project_name = "fusioniq"
    environment = "dev"
    terraform = true
  }
}

variable "skip_final_snapshot" {
  default = true
}

# variable "performance_insights_enabled" {
#   default = true
# }