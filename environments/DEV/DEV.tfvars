environment = "dev"
project_name = "fusioniq"
region = "us-east-1"

# VPC
cidr_block = "10.0.0.0/16"
cidr_public = ["10.0.1.0/24","10.0.2.0/24"]
cidr_private = ["10.0.3.0/24","10.0.4.0/24"]
cidr_database = ["10.0.5.0/24","10.0.6.0/24"]


# Bastion
 ec2_tags = {
    Name = "bastion-dev"
    project_name = "fusioniq"
    terraform = true
}

# RDS
rds_parameter_grp_name = "rds-parameter-group-dev"
allocated_storage = 20 # GiB
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.41"
instance_class = "db.t3.micro"
identifier = "fusioniq"
db_name = "dev"
username = "admin"
manage_master_user_password = true
publicly_accessible = false
skip_final_snapshot= true

# EKS
node_groups = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      node_group_name = "fusioniq-dev-node"
      scaling_config = {
        desired_size = 1
        max_size     = 3
        min_size     = 1
      }
    }
}

# # Route53
domain_name = "royalreddy.site" # domain 
record_cname_type = "CNAME"
record_a_type = "A"
ttl = 60


