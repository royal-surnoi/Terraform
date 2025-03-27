variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "identifier" {
  type = string
}
variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "manage_master_user_password" {
  type = bool
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

variable "publicly_accessible" {
  type = bool
}

variable "parameter_group_name" {
  type = string
}

variable "skip_final_snapshot" {
  type = string
}

# variable "performance_insights_enabled" {
#   type = bool
# }

variable "common_tags" {
  default = {}
}

variable "db_tags" {
  default = {}
}


variable "project_name" {
  type = string
}
variable "environment" {
  type = string
}