pipeline{
    agent any
    options{
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: "HOURS")
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    parameters{
        choice(name: 'ENVIRONMENT', choices: ['DEV', 'UAT', 'PROD'], description: 'Choose the environment')
        choice(name: 'OPERATION', choices: ['Create', 'Destroy'], description: 'Choose the operation')
    }
    stages{
        stage('Setup'){
            steps{
                script {
                    // Validate parameters
                    if (!params.ENVIRONMENT || !params.OPERATION) {
                        error "Environment or Operation not specified!"
                    }
                    echo "Running ${params.OPERATION} for ${params.ENVIRONMENT}"
                }
            } 
        }
        stage('Terraform init'){
            steps{
                sh """
                    terraform init -reconfigure -backend-config=environments/"${params.ENVIRONMENT}"/backend.tf
                """
            }
        }
        stage('Terraform Apply/Destroy'){   
            steps {
                script {
                    if (params.OPERATION == "Create") {
                        echo "${params.ENVIRONMENT} stage create"
                        if (params.ENVIRONMENT == 'PROD') {
                            // Require manual approval for PROD
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
    }
}