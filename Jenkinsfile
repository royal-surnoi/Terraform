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
        // stage('Setup ALB Ingress Controller') {
        //     when {
        //         expression { params.OPERATION == 'Create' }
        //     }
        //     steps {
        //         script {
        //            sh '''
        //                 # Create bin directory
        //                 mkdir -p /var/lib/jenkins/bin

        //                 # Install kubectl if not present
        //                 if [ ! -f /var/lib/jenkins/bin/kubectl ]; then
        //                     curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
        //                     chmod +x kubectl
        //                     mv kubectl /var/lib/jenkins/bin/
        //                 fi

        //                 # Install helm if not present
        //                 if [ ! -f /var/lib/jenkins/bin/helm ]; then
        //                     curl -LO https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz
        //                     tar -zxvf helm-v3.17.3-linux-amd64.tar.gz
        //                     mv linux-amd64/helm /var/lib/jenkins/bin/
        //                     rm -rf linux-amd64 helm-v3.17.3-linux-amd64.tar.gz
        //                 fi

        //                 # Install eksctl if not present
        //                 if [ ! -f /var/lib/jenkins/bin/eksctl ]; then
        //                     curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
        //                     mv /tmp/eksctl /var/lib/jenkins/bin/
        //                 fi

        //                 # Install jq if not present
        //                 if [ ! -f /var/lib/jenkins/bin/jq ]; then
        //                     curl -L -o /var/lib/jenkins/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
        //                     chmod +x /var/lib/jenkins/bin/jq
        //                 fi

        //                 # Verify tools
        //                 kubectl version --client
        //                 helm version
        //                 eksctl version
        //                 jq --version
        //             '''

        //             // Extract Terraform outputs
        //             sh '''
        //                 terraform output -json > outputs.json
        //                 export CLUSTER_NAME=$(jq -r '.cluster_name.value' outputs.json)
        //                 export REGION=$(jq -r '.region.value' outputs.json)
        //                 export ACCOUNT_ID=$(jq -r '.account_id.value' outputs.json)
        //                 export VPC_ID=$(jq -r '.vpc_id.value' outputs.json)
        //                 export SUBNET_IDS=$(jq -r '.public_subnet_ids.value | join(" ")' outputs.json)

        //                 # Run the ALB setup script
        //                 chmod +x scripts/setup-alb-ingress.sh
        //                 ./scripts/setup-alb-ingress.sh
        //             '''

        //             sh '''
        //                 kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
        //             '''
        //         }
        //     }
        // }
    }
}