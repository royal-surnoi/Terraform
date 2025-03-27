variable "vpc_id" {
  default = "vpc-0d6e5535cf4beb00a"
}

variable "security_group_name" {
  default = "sample"
}

variable "security_group_description" {
  default = "Allowing SSH,HTTP and all traffic"
}

variable "common_tags" {
  default = {
    project_name = "fusioniq"
    environment = "dev"
    terraform = true
  }
}

variable "security_group_tags" {
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
    key2 = { 
        cidr_ipv4         = "0.0.0.0/0"
        from_port         = 80
        ip_protocol       = "tcp"
        to_port           = 80
    }
    key3 = { # make sure all traffic is required
        cidr_ipv4         = "0.0.0.0/0"
        ip_protocol       = "-1"
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