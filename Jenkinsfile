pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: "HOURS")
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['DEV', 'UAT', 'PROD'], description: 'Choose the environment')
        choice(name: 'OPERATION', choices: ['Create', 'Destroy'], description: 'Choose the operation')
    }
    stages {
        stage('Setup') {
            steps {
                script {
                    // Validate parameters
                    if (!params.ENVIRONMENT || !params.OPERATION) {
                        error "Environment or Operation not specified!"
                    }
                    echo "Running ${params.OPERATION} for ${params.ENVIRONMENT}"
                }
            }
        }
        stage('Terraform init') {
            steps {
                sh """
                    terraform init -reconfigure -backend-config=environments/"${params.ENVIRONMENT}"/backend.tf
                """
            }
        }
        stage('Terraform Apply/Destroy') {
            steps {
                script {
                    if (params.OPERATION == "Create") {
                        echo "${params.ENVIRONMENT} stage create"
                        if (params.ENVIRONMENT == 'PROD') {
                            input message: "Approve for create PROD environment?"
                        }
                        sh """
                            terraform apply -var-file=environments/"${params.ENVIRONMENT}"/"${params.ENVIRONMENT}".tfvars -auto-approve
                        """
                    } else if (params.OPERATION == "Destroy") {
                        echo "${params.ENVIRONMENT} stage destroy"
                        if (params.ENVIRONMENT == 'PROD') {
                            input message: "Approve for destroy PROD environment?"
                        }
                        sh """
                            terraform destroy -var-file=environments/"${params.ENVIRONMENT}"/"${params.ENVIRONMENT}".tfvars -auto-approve
                        """
                    }
                }
            }
        }
        stage('Setup ALB Ingress Controller') {
            when {
                expression { params.OPERATION == 'Create' }
            }
            steps {
                script {
                    // Install required tools
                    sh '''
                        # Install kubectl
                        curl -LO "https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        sudo mv kubectl /usr/local/bin/

                        # Install helm
                        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
                        chmod 700 get_helm.sh
                        ./get_helm.sh
                        rm get_helm.sh

                        # Install eksctl
                        curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
                        sudo mv /tmp/eksctl /usr/local/bin

                        # Install jq
                        sudo apt-get update
                        sudo apt-get install -y jq
                    '''

                    // Extract Terraform outputs
                    sh '''
                        terraform output -json > outputs.json
                        export CLUSTER_NAME=$(jq -r '.cluster_name.value' outputs.json)
                        export REGION=$(jq -r '.region.value' outputs.json)
                        export ACCOUNT_ID=$(jq -r '.account_id.value' outputs.json)
                        export VPC_ID=$(jq -r '.vpc_id.value' outputs.json)
                        export SUBNET_IDS=$(jq -r '.public_subnet_ids.value | join(" ")' outputs.json)

                        # Run the ALB setup script
                        chmod +x scripts/setup-alb-ingress.sh
                        ./scripts/setup-alb-ingress.sh
                    '''
                }
            }
        }
    }
}