# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

# Bastion
output "security_group_id" {
  value = module.security_group.security_group_id
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "key_name" {
  value = module.key_pair.key_name
}

# Amazon RDS
output "rds_end_point" {
  value = module.aws-rds.end_point
}

# AWS EKS
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}