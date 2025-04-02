# resource "aws_route53_record" "www" {
#   zone_id = var.zone_id
#   name    = var.environment == "prod" ? var.name : "${var.environment}.${var.name}"
#   type    = var.type
#   ttl     = var.ttl
#   records = var.records
# }

