# Project Infrastructure

## Scope: 

Set up core AWS infrastructure to support application deployment and operations 

### Components: 

#### Custom Modules Development: 

1. Develop Terraform reusable modules for VPC, RDS, EKS, S3, Route53, and Security Groups. 

2. VPC (Virtual Private Cloud): 
    - Create a custom VPC with public and private subnets. 

    - Configure NAT Gateways and Internet Gateway. 

3. AWS RDS: 

    - Provision Mysql RDS in private subnets. 
    - Set up parameter groups and subnet groups. 
    - Enable automated backups, monitoring, and multi-AZ if required. 

4. AWS EKS (Elastic Kubernetes Service): 

    - Create an EKS cluster in the private subnet. 

    - Configure Node Groups (Auto Scaling). 

    - IAM Roles for service accounts. 

5. Route53: 

    - Set up private and public hosted zones. 

    - Manage DNS records for DEV environment. 

6. S3 Bucket (Artifact Storage): 

    - Create S3 buckets for storing build artifacts, Helm charts, and backups. 

7. Security Groups: 

    - Define security groups for: 

        - EC2 Instances 

        - EKS Nodes 

        - RDS Instances 

    - Apply least privilege and necessary port access rules. 