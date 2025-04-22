environment = "prod"
project_name = "fusioniq"

# VPC
cidr_block = "10.1.0.0/16"
cidr_public = ["10.1.1.0/24","10.1.2.0/24"]
cidr_private = ["10.1.3.0/24","10.1.4.0/24"]
cidr_database = ["10.1.5.0/24","10.1.6.0/24"]


# Bastion
 ec2_tags = {
    Name = "bastion-prod"
    project_name = "fusioniq"
    terraform = true
}

# RDS
rds_parameter_grp_name = "rds-parameter-group-prod"
allocated_storage = 30 # GiB
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.41"
instance_class = "db.t3.large"
identifier = "fusioniq"
db_name = "prod"
username = "admin"
manage_master_user_password = true
publicly_accessible = false
skip_final_snapshot= true

# EKS
node_groups = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      node_group_name = "fusioniq-prod-node"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 2
      }
    }
}

# # Route53
# zone_id = ""
# name = "" # domain 
# type = "" # record type
# ttl = 300 
# record = [""]