## README for AWS RDS Terraform Module

## Aproach 
- RDS instance creation
- Parameter group creation
- Subnet group creation
- Security group configuration



---

### `main.tf`
```hcl
# Instance for RDS 
resource "aws_db_instance" "mysql" {
  allocated_storage            = var.allocated_storage
  storage_type                 = var.storage_type
  engine                       = var.engine
  engine_version               = var.engine_version
  instance_class               = var.instance_class
  identifier                   = var.identifier
  db_name                      = var.db_name
  username                     = var.username
  manage_master_user_password  = var.manage_master_user_password
  publicly_accessible          = var.publicly_accessible
  vpc_security_group_ids       = var.vpc_security_group_ids
  db_subnet_group_name         = var.db_subnet_group_name
  parameter_group_name         = var.parameter_group_name
  skip_final_snapshot          = var.skip_final_snapshot

  # Optional settings for backups, maintenance, and monitoring
  backup_retention_period      = var.backup_retention_period
  backup_window                = var.backup_window
  maintenance_window           = var.maintenance_window
  monitoring_interval          = var.monitoring_interval
  monitoring_role_arn          = var.monitoring_role_arn
  performance_insights_enabled = var.performance_insights_enabled

  tags = merge(
    var.common_tags,
    var.db_tags,
    {
      Name = "${var.identifier}"
    }
  )
}
```

---

### Input Variables List
1. `allocated_storage` – Storage size in GB. Example: `20`  
2. `storage_type` – Type of storage (e.g., `gp2`, `io1`). Example: `"gp2"`  
3. `engine` – Database engine (e.g., `mysql`, `postgres`). Example: `"mysql"`  
4. `engine_version` – Database engine version. Example: `"8.0.32"`  
5. `instance_class` – Instance class type. Example: `"db.t3.medium"`  
6. `identifier` – RDS instance identifier. Example: `"fusioniq-rds"`  
7. `db_name` – Name of the database. Example: `"fusioniq"`  
8. `username` – Database admin username. Example: `"admin"`  
9. `db_password` – Database admin password. Example: `"securepassword"`  
10. `publicly_accessible` – Whether RDS is publicly accessible (`true`/`false`). Example: `false`  
11. `skip_final_snapshot` – Skip final snapshot on delete (`true`/`false`). Example: `true`  
12. `backup_retention_period` – Backup retention period in days. Example: `7`  
13. `backup_window` – Backup window time. Example: `"03:00-04:00"`  
14. `maintenance_window` – Maintenance window time. Example: `"mon:04:00-mon:04:30"`  
15. `monitoring_interval` – Monitoring interval in seconds. Example: `60`  
16. `monitoring_role_arn` – IAM role ARN for monitoring. Example: `""`  
17. `performance_insights_enabled` – Enable performance insights (`true`/`false`). Example: `true`  
18. `common_tags` – Common tags for resources. Example: `{ Name = "fusioniq" }`  
19. `db_tags` – Additional database tags. Example: `{ Environment = "DEV" }`  
20. `vpc_id` – VPC ID. Example: `"vpc-12345678"`  
21. `subnet_ids` – List of subnet IDs for RDS subnet group. Example: `["subnet-12345678", "subnet-87654321"]`  
22. `allowed_cidr_blocks` – CIDR blocks allowed to access RDS. Example: `["10.0.0.0/16"]`  
23. `db_subnet_group_name` – Subnet group name. Example: `"fusioniq-db-subnet"`  
24. `parameter_group_name` – Parameter group name. Example: `"fusioniq-db-param-group"`  
25. `db_parameter_group_family` – Parameter group family (e.g., `mysql8.0`). Example: `"mysql8.0"`  

---

### Output Variables List  
1. `rds_endpoint` – The connection endpoint for the RDS instance. Example: `fusioniq-rds.cnt8cxyz.us-east-1.rds.amazonaws.com`  
2. `rds_arn` – Amazon Resource Name (ARN) for the RDS instance. Example: `arn:aws:rds:us-east-1:123456789012:db:fusioniq-rds`