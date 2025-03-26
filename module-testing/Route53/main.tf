module "route53" {
  source   = "../../modules/Route53"  # Path to your Route 53 module
  zone_id  = var.zone_id
  name     = "${var.env}.${var.name}"
  ttl      = var.ttl
  records  = var.records  # Replace with your actual Elastic IP or DNS
}