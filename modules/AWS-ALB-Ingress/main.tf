provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

# IAM Policy for ALB Ingress Controller
resource "aws_iam_policy" "alb_ingress" {
  name   = "${var.cluster_name}-alb-ingress-policy"
  policy = file("${path.module}/alb-policy.json")
}

# IAM Role for ALB Ingress Controller
locals {
  oidc_provider_url = replace(var.oidc_provider_arn, "arn:aws:iam::[0-9]+:oidc-provider/", "")
}

resource "aws_iam_role" "alb_ingress" {
  name = "${var.cluster_name}-alb-ingress-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${local.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller",
          "${local.oidc_provider_url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "alb_ingress" {
  role       = aws_iam_role.alb_ingress.name
  policy_arn = aws_iam_policy.alb_ingress.arn
}

# Helm Release for AWS Load Balancer Controller
resource "helm_release" "alb_ingress" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.9.2" # Upgraded from var.alb_ingress_version
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_ingress.arn
  }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
  set {
    name  = "region"
    value = "us-east-1"
  }
  set {
    name  = "rbac.create"
    value = "true"
  }

  depends_on = [aws_iam_role_policy_attachment.alb_ingress]
}