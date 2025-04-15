output "public_subnet_ids" {
  description = "public_subnets"
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "private_subnets"
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

# Bastion
output "security_group_id" {
  value = module.security_group.security_group_id
}

output "bastion_public_ip" {
  value = module.ec2_instance.bastion_public_ip
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

output "region" {
  value = var.region
}

output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

# output "subnet_ids" {
#   description = "public_subnets"
#   value = module.vpc.public_subnet_ids
# }

data "aws_caller_identity" "current" {}





output "output" {
  value = <<EOF

################################################################################
                             INFRASTRUCTURE SUMMARY                           
################################################################################

############################# VPC Details ######################################
  vpc_id                           ${module.vpc.vpc_id}
  public_subnet_ids                ${join(", ", module.vpc.public_subnet_ids)}
  private_subnet_ids               ${join(", ", module.vpc.private_subnet_ids)}
  database_subnet_ids              ${join(", ", module.vpc.database_subnet_ids)}

############################# Bastion Host Info #################################
  public_ip                        ${module.ec2_instance.bastion_public_ip}
  key_pair_name                    ${module.key_pair.key_name}
  Note: If created via Jenkins, the .pem file is located at:
      /var/lib/jenkins/workspace/<repo>
      Ensure it's secured and not committed to version control.
      bastion_ssh_cmd = "ssh -i /path/to/key.pem ec2-user@${module.ec2_instance.bastion_public_ip}"

############################# RDS (Database) Info ################################
  rds_end_point                    ${module.aws-rds.end_point}
  rds_dns_name                     ${aws_route53_record.database.name}

############################# EKS Cluster Info  ###################################
  cluster_endpoint                 ${module.eks.cluster_endpoint}
  cluster_name                     ${module.eks.cluster_name}
  To connect to EKS cluster:
    aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}

############################# Route53 (DNS) Info ###################################
  database_dns_record              ${aws_route53_record.database.name}
  EOF
}