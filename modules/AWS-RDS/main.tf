# Instance for RDS 
resource "aws_db_instance" "mysql" {
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  identifier = var.identifier
  db_name = var.db_name
  username = var.username
  manage_master_user_password = var.manage_master_user_password
  publicly_accessible = var.publicly_accessible
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = var.db_subnet_group_name

#   backup_retention_period = 7
#   backup_window = "03:00-04:00"
#   maintenance_window = "mon:04:00-mon:04:30"
#   skip_final_snapshot = false
#   monitoring_interval = 60
#   monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
  # performance_insights_enabled = true

  # Associate with parameter group
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot       = var.skip_final_snapshot
  tags = merge(
    var.common_tags,
    var.db_tags,
    {
        Name = local.name
   }
  )
}