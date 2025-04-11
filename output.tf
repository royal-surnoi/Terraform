output "output" {
  value = <<EOF

  ############################# VPC ###########################################
  vpc_id                           ${module.vpc.vpc_id}
  public_subnet_ids                ${join(", ", module.vpc.public_subnet_ids)}
  private_subnet_ids               ${join(", ", module.vpc.private_subnet_ids)}
  database_subnet_ids              ${join(", ", module.vpc.database_subnet_ids)}

  ############################# Bastion-Host #######################################
  public_ip                        ${module.ec2_instance.bastion_public_ip}
  key_pair_name                    ${module.key_pair.key_name}
  Note: If you are creating infra with Jenkins , can find .pem in /var/lib/jenkin/workspace/<repo>

  ############################# Database ############################################
  rds_end_point                    ${module.aws-rds.end_point}
  host_name                        ${aws_route53_record.database.name}
  ############################# EKS ################################################
  cluster_endpoint                 ${module.eks.cluster_endpoint}
  cluster_name                     ${module.eks.cluster_name}
  Connect Cluster: aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}
  ############################# Route53 ################################################
  database_host_name               ${aws_route53_record.database.name}
  Internet_access                  ${aws_route53_record.web.name}

  EOF
}




# # VPC
# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "public_subnet_ids" {
#   value = module.vpc.public_subnet_ids
# }

# output "private_subnet_ids" {
#   value = module.vpc.private_subnet_ids
# }

# output "database_subnet_ids" {
#   value = module.vpc.database_subnet_ids
# }

# # Bastion
# output "security_group_id" {
#   value = module.security_group.security_group_id
# }

# output "bastion_public_ip" {
#   value = module.ec2_instance.bastion_public_ip
# }

# output "key_name" {
#   value = module.key_pair.key_name
# }

# # Amazon RDS
# output "rds_end_point" {
#   value = module.aws-rds.end_point
# }

# # AWS EKS
# output "cluster_endpoint" {
#   description = "EKS cluster endpoint"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_name" {
#   description = "EKS cluster name"
#   value       = module.eks.cluster_name
# }