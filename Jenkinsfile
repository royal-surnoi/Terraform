pipeline{
    agent any
    options{
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: "HOURS")
    }
    parameters{
        choice(name: 'ENVIRONMENT', choices: ['DEV', 'UAT', 'PROD'], description: 'choose the environment')
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
        // stage('UAT-stage'){
        //     when {
        //         expression {
        //             params.enviornments == "UAT"
        //         }
        //     }
        //     steps {
        //         sh """
        //             terraform init -reconfigure -backend-config=environments/"${params.enviornments}"/backend.tf
        //         """
        //         script {
        //             if (params.operation == "Create") {
        //                 echo 'UAT stage create'
        //                 sh """
        //                     terraform apply -var-file=environments/"${params.enviornments}"/uat.tfvars -auto-approve
        //                 """
        //                  // Code for Option A
        //             } else if (params.operation == "Destroy") {
        //                 echo 'UAT stage destroy'
        //                 sh """
        //                     terraform destroy -var-file=environments/"${params.enviornments}"/uat.tfvars -auto-approve
        //                 """
        //                 // Code for Option B
        //             }
        //         }
        //     }  
        // }

        // stage('Production-stage'){
        //     when {
        //         expression {
        //             params.enviornments == "PROD"
        //         }
        //     }
        //     steps {
        //         sh """
        //             terraform init -reconfigure -backend-config=environments/"${params.enviornments}"/backend.tf
        //         """
        //         script {
        //             if (params.operation == "Create") {
        //                 echo 'Prod stage create'
        //                 sh """
        //                     terraform apply -var-file=environments/"${params.enviornments}"/prod.tfvars -auto-approve
        //                 """
        //                  // Code for Option A
        //             } else if (params.operation == "Destroy") {
        //                 echo 'Prod stage destroy'
        //                 sh """
        //                     terraform destroy -var-file=environments/"${params.enviornments}"/uat.tfvars -auto-approve
        //                 """
        //                 // Code for Option B
        //             }
        //         }
        //     }  
        // }
    }
}