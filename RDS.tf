# A parameter group is a collection of engine configuration values that you set for your RDS database instance
resource "aws_db_parameter_group" "rds_parameter_grp" {
  name        = var.rds_parameter_grp_name
  description = "Parameter group for mysql8.0"
  family      = "mysql8.0"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "${var.identifier}-${var.environment}-subnet-group"
  subnet_ids = module.vpc.database_subnet_ids
}

module "db_security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
  security_group_config = {
    name        = "${var.project_name}-${var.environment}-${var.db_security_group_name}"
    description = var.db_security_group_description
    tags        = var.security_group_tags
  }
  project_name                  = var.project_name
  environment                   = var.environment
  common_tags                   = var.common_tags
  security_group_ingress_config = var.security_group_ingress

  security_group_egress_config = var.db_security_group_egress_config
}

module "aws-rds" {
  source                      = "./modules/AWS-RDS"
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  identifier                  = "${var.identifier}-${var.environment}"
  db_name                     = var.db_name
  username                    = var.username
  manage_master_user_password = var.manage_master_user_password
  publicly_accessible         = var.publicly_accessible
  vpc_security_group_ids      = [module.db_security_group.security_group_id]
  db_subnet_group_name        = aws_db_subnet_group.my_db_subnet_group.name
  parameter_group_name        = aws_db_parameter_group.rds_parameter_grp.name
  skip_final_snapshot         = var.skip_final_snapshot
  project_name                = var.project_name
  environment                 = var.environment
  common_tags                 = var.common_tags
  #   backup_retention_period = 7
  #   backup_window = "03:00-04:00"
  #   maintenance_window = "mon:04:00-mon:04:30"
  #   skip_final_snapshot = false
  #   final_snapshot_identifier = ""
  #   monitoring_interval = 60
  #   monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
  # performance_insights_enabled = true

  # Associate with parameter group

}