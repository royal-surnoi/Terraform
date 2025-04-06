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
  # performance_insights_enabled = true
  # Associate with parameter group
  # monitoring_interval = 60
  # monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot       = var.skip_final_snapshot
  tags = merge(
    var.common_tags,
    var.db_tags,
    {
        Name = "${local.name}-db"
   }
  )
}

resource "aws_iam_role" "rds_monitoring_role" {
  name               = "rds-monitoring-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]
}

# Create IAM Policy for RDS Enhanced Monitoring
resource "aws_iam_policy" "rds_monitoring_policy" {
  name        = "rds-monitoring-policy-${var.environment}"
  description = "Policy to allow Enhanced Monitoring for RDS instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricData",
          "rds:DescribeDBInstances",
          "rds:DescribeEvents",
          "rds:DescribeDBLogFiles",
          "rds:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "rds_monitoring_policy_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = aws_iam_policy.rds_monitoring_policy.arn
}

