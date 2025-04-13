# output "oidc_provider_arn" {
#   description = "ARN of the OIDC provider for the EKS cluster"
#   value       = data.oidc_provider_arn.arn
# }

output "alb_ingress_role_arn" {
  description = "ARN of the IAM role for ALB Ingress Controller"
  value       = aws_iam_role.alb_ingress.arn
}