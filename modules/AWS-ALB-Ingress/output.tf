output "alb_ingress_role_arn" {
  description = "ARN of the IAM role for ALB Ingress Controller"
  value       = aws_iam_role.alb_ingress.arn
}