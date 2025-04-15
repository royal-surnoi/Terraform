#!/bin/bash

# Shell script to configure AWS ALB Ingress Controller on an EKS cluster
# Designed for Jenkins project-infra pipeline

# Exit on any error
set -e

# Variables (set via Jenkins environment variables or Terraform outputs)
CLUSTER_NAME="${CLUSTER_NAME}"
REGION="${REGION}"
ACCOUNT_ID="${ACCOUNT_ID}"
VPC_ID="${VPC_ID}"
SUBNET_IDS="${SUBNET_IDS}"
IAM_POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
SERVICE_ACCOUNT_NAME="aws-load-balancer-controller"
NAMESPACE="kube-system"
HELM_REPO_NAME="eks"
HELM_CHART="eks/aws-load-balancer-controller"
IAM_POLICY_URL="https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json"

# Function to check if a command succeeded
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1 || { echo "Error: $1 is required but not installed."; exit 1; }
}

# Validate inputs
echo "Validating inputs..."
[ -z "$CLUSTER_NAME" ] && { echo "Error: CLUSTER_NAME is required"; exit 1; }
[ -z "$REGION" ] && { echo "Error: REGION is required"; exit 1; }
[ -z "$ACCOUNT_ID" ] && { echo "Error: ACCOUNT_ID is required"; exit 1; }
[ -z "$VPC_ID" ] && { echo "Error: VPC_ID is required"; exit 1; }
[ -z "$SUBNET_IDS" ] && { echo "Error: SUBNET_IDS is required"; exit 1; }

# Verify required tools
echo "Checking for required tools..."
command_exists eksctl
command_exists aws
command_exists kubectl
command_exists helm
command_exists curl
command_exists jq

# Skip if ALB controller is already deployed
echo "Checking if ALB controller is already deployed..."
if kubectl get deployment aws-load-balancer-controller -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "ALB controller already deployed, skipping setup..."
    exit 0
fi

# Update kubeconfig to ensure kubectl can access the cluster
echo "Updating kubeconfig for cluster $CLUSTER_NAME..."
aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"
check_status "Failed to update kubeconfig"

# Step 1: Create IAM OIDC provider for the cluster
echo "Creating IAM OIDC provider for cluster $CLUSTER_NAME..."
eksctl utils associate-iam-oidc-provider \
    --region "$REGION" \
    --cluster "$CLUSTER_NAME" \
    --approve
check_status "Failed to create IAM OIDC provider"

# Step 2: Download IAM policy JSON
echo "Downloading IAM policy JSON..."
curl -o iam-policy.json "$IAM_POLICY_URL"
check_status "Failed to download IAM policy JSON"
[ -f iam-policy.json ] || { echo "Error: iam-policy.json not found"; exit 1; }

# Step 3: Create IAM policy
echo "Creating IAM policy $IAM_POLICY_NAME..."
aws iam create-policy \
    --policy-name "$IAM_POLICY_NAME" \
    --policy-document file://iam-policy.json \
    --region "$REGION" || {
        echo "IAM policy creation failed or already exists. Checking if it exists..."
        aws iam get-policy \
            --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/$IAM_POLICY_NAME" \
            --region "$REGION" >/dev/null 2>&1
        check_status "IAM policy does not exist and could not be created"
    }
check_status "Failed to verify or create IAM policy"

# Step 4: Delete existing IAM service account (if any)
echo "Deleting existing IAM service account (if any)..."
eksctl delete iamserviceaccount \
    --cluster "$CLUSTER_NAME" \
    --name "$SERVICE_ACCOUNT_NAME" \
    --namespace "$NAMESPACE" \
    --region "$REGION" || echo "No existing service account to delete"

# Step 5: Create IAM role and service account
echo "Creating IAM role and service account $SERVICE_ACCOUNT_NAME..."
eksctl create iamserviceaccount \
    --cluster "$CLUSTER_NAME" \
    --namespace "$NAMESPACE" \
    --name "$SERVICE_ACCOUNT_NAME" \
    --attach-policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/$IAM_POLICY_NAME" \
    --override-existing-serviceaccounts \
    --region "$REGION" \
    --approve
check_status "Failed to create IAM service account"

# Step 6: Install TargetGroupBinding CRDs
echo "Installing TargetGroupBinding CRDs..."
kubectl apply -k github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master
check_status "Failed to install CRDs"

# Verify CRDs
echo "Verifying CRDs..."
kubectl get crd | grep -E "targetgroupbindings|ingresses"
check_status "Failed to verify CRDs"

# Step 7: Add Helm repository
echo "Adding Helm repository $HELM_REPO_NAME..."
helm repo add "$HELM_REPO_NAME" https://aws.github.io/eks-charts
check_status "Failed to add Helm repository"
helm repo update
check_status "Failed to update Helm repository"

# Step 8: Deploy AWS Load Balancer Controller Helm chart
echo "Deploying AWS Load Balancer Controller..."
helm upgrade -i aws-load-balancer-controller "$HELM_CHART" \
    -n "$NAMESPACE" \
    --set clusterName="$CLUSTER_NAME" \
    --set serviceAccount.create=false \
    --set serviceAccount.name="$SERVICE_ACCOUNT_NAME" \
    --set vpcId="$VPC_ID"
check_status "Failed to deploy Helm chart"

# Step 9: Verify controller pods
echo "Checking controller pods..."
kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=aws-load-balancer-controller
check_status "Failed to list controller pods"


# Clean up
echo "Cleaning up temporary files..."
rm -f iam-policy.json

echo "AWS ALB Ingress Controller setup completed successfully!"

exit 0