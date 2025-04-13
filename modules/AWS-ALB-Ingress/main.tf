# Kubernetes provider (if not already present)
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

# ClusterRole for AWS Load Balancer Controller
resource "kubernetes_cluster_role" "alb_ingress_controller" {
  metadata {
    name = "alb-ingress-controller"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "nodes", "endpoints", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update", "patch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["get", "create", "update", "delete", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}

# ClusterRoleBinding for AWS Load Balancer Controller
resource "kubernetes_cluster_role_binding" "alb_ingress_controller" {
  metadata {
    name = "alb-ingress-controller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.alb_ingress_controller.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "alb-ingress-controller"
    namespace = "kube-system"
  }
}

# Update Helm release to depend on RBAC resources
# resource "helm_release" "alb_ingress" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   version    = var.alb_ingress_version
#   namespace  = "kube-system"
#   depends_on = [
#     aws_iam_role_policy_attachment.alb_ingress,
#     kubernetes_cluster_role_binding.alb_ingress_controller
#   ]

#   set {
#     name  = "clusterName"
#     value = var.cluster_name
#   }
#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }
#   set {
#     name  = "serviceAccount.name"
#     value = "alb-ingress-controller"
#   }
#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.alb_ingress.arn
#   }
#   set {
#     name  = "image.tag"
#     value = var.alb_ingress_image_tag
#   }
#   set {
#     name  = "vpcId"
#     value = var.vpc_id
#   }
#   set {
#     name  = "rbac.create"
#     value = "true"
#   }
# }

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
          "${local.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:alb-ingress-controller",
          "${local.oidc_provider_url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}


# IAM Policy for ALB Ingress Controller
resource "aws_iam_policy" "alb_ingress" {
  name   = "${var.cluster_name}-alb-ingress-policy"
  policy = file("${path.module}/alb-policy.json")
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "alb_ingress" {
  role       = aws_iam_role.alb_ingress.name
  policy_arn = aws_iam_policy.alb_ingress.arn
}

# Helm Provider Configuration
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

# Helm Release for ALB Ingress Controller
resource "helm_release" "alb_ingress" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.alb_ingress_version
  namespace  = "kube-system"
  depends_on = [aws_iam_role_policy_attachment.alb_ingress]

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
    value = "alb-ingress-controller"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.alb_ingress.arn
  }
  # set {
  #   name  = "image.tag"
  #   value = var.alb_ingress_image_tag
  # }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
}

