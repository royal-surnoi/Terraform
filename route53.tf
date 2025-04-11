# data "aws_route53_zone" "selected" {
#   name         = var.name
#   private_zone = true
# }

# resource "aws_route53_record" "db" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = var.environment == "prod" ? "db.${var.name}" : "${var.environment}db.${var.name}"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [module.aws-rds.end_point]
# }

# resource "aws_route53_record" "web" {
#   zone_id = var.zone_id
#   name    = var.environment == "prod" ? var.name : "${var.environment}.${var.name}"
#   type    = var.type
#   ttl     = var.ttl
#   records = var.records
# }

