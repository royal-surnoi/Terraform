terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.0"
    }

  }


  # backend "s3" {
  #   bucket = "eks-control-plane-s3"
  #   key    = "LockID"
  #   region = "us-east-1"
  # }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

provider "aws" {
  region = "us-east-1"
}