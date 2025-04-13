resource "aws_route53_zone" "private" {
  name = "${var.project_name}.com"
  vpc {
    vpc_id = module.vpc.vpc_id
  }
  tags = {
    project     = var.project_name
    environment = var.environment
    terraform   = true
  }
}

# resource "aws_route53_zone" "public" {
#   name = var.domain_name
#   tags = {
#     project     = var.project_name
#     environment = var.environment
#     terraform   = true
#   }
# }


# data "aws_route53_zone" "public" {
#   name         = var.domain_name
# }

data "aws_db_instance" "database" {
  db_instance_identifier = module.aws-rds.identifier
  depends_on             = [module.aws-rds]
}

resource "aws_route53_record" "database" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "${var.environment}.db.${var.project_name}.com"
  type    = var.record_cname_type
  ttl     = var.ttl
  records = [data.aws_db_instance.database.address]
}

# resource "aws_route53_record" "web" {
#   zone_id = data.aws_route53_record.public.zone_id
#   name    = var.environment == "prod" ? var.domain_name : "${var.environment}.${var.domain_name}"
#   type    = var.record_cname_type
#   ttl     = var.ttl
#   records = [data.aws_db_instance.database.address] # for testing added
# }

