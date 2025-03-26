resource "aws_route53_record" "www" {
  zone_id = var.zone_id  # The zone_id from the root module
  name    = var.name
  type    = "A"  # Type of record (A record for IP addresses)
  ttl     = var.ttl
  records = var.records  # The records (IP addresses or CNAME)

}
