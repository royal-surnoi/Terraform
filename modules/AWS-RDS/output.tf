output "end_point" {
  value = aws_db_instance.mysql.endpoint
}


output "rds_monitoring_role" {
  value = aws_iam_role.rds_monitoring_role.arn
}


output "identifier" {
  value = aws_db_instance.mysql.identifier
}
