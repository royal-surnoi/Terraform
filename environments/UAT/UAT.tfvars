environment = "uat"
project_name = "fusioniq"

# VPC
cidr_block = "10.2.0.0/16"
cidr_public = ["10.2.1.0/24","10.2.2.0/24"]
cidr_private = ["10.2.3.0/24","10.2.4.0/24"]
cidr_database = ["10.2.5.0/24","10.2.6.0/24"]


# Bastion
 ec2_tags = {
    Name = "bastion-uat"
    project_name = "fusioniq"
    terraform = true
}

# RDS
rds_parameter_grp_name = "rds-parameter-group-uat"
allocated_storage = 20 # GiB
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.41"
instance_class = "db.t3.micro"
identifier = "fusioniq"
db_name = "uat"
username = "admin"
manage_master_user_password = true
publicly_accessible = false
skip_final_snapshot= true

# EKS
node_groups = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      node_group_name = "fusioniq-uat-node"
      scaling_config = {
        desired_size = 1
        max_size     = 5
        min_size     = 1
      }
    }
}

# Route53
# zone_id = ""
# name = "" # domain 
# type = "" # record type
# ttl = 300 
# record = [""]

