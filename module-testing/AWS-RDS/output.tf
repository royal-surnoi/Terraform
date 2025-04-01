output "rds_end_point" {
  value = module.aws-rds.end_point
}

output "role_arn" {
  value = module.aws-rds.rds_monitoring_role
}
