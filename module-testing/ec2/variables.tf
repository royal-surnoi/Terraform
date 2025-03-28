# EC2-variables
variable "ami" {
  default = "ami-01816d07b1128cd2d"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_tags" {
  default = {
    Name = "bastion"
    project_name = "fusioniq"
    environment = "dev"
    terraform = true
  }
}

variable "subnet_id" {
  default = "subnet-0ef565828b0f38092"
}


# secuity_group-variables
variable "security_group_name" {
  default = "bastion"
}

variable "vpc_id" {
  default = "vpc-02f1b64639129a548"
}

variable "security_group_description" {
  default = "Allowing SSH,HTTP and all traffic"
}

variable "common_tags" {
  default = {
    project_name = "fusioniq"
    environment = "dev"
    component = "bastion"
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
        from_port         = 22
        ip_protocol       = "tcp"
        to_port           = 22
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