variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Certificate authority data for the EKS cluster"
  type        = string
}

variable "alb_ingress_version" {
  description = "Helm chart version for ALB Ingress Controller"
  default     = "2.7.1"
}

# variable "alb_ingress_image_tag" {
#   description = "Docker image tag for the ALB Ingress Controller"
#   default     = "v2.4.4"
# }

variable "vpc_id"{
  description = "VPC ID"
  type = string
}
