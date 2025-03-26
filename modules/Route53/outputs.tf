output "route53_record_name" {
  description = "The name of the Route 53 record"
  value       = aws_route53_record.www.name
}

output "route53_record_ip" {
  description = "The IP addresses the Route 53 record points to"
  value       = aws_route53_record.www.records
}
