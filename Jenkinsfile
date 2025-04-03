pipeline{
    agent any
    options{
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: "HOURS")
    }
    parameters{
        choice(name: 'enviornments', choices: ['DEV', 'UAT', 'PROD'], description: 'choose the environment')
        choice(name: 'operation', choices: ['Create', 'Destroy'], description: 'Choose the operation')
    }
    stages{
        stage('Development-stage'){
            when {
                expression {
                    params.enviornments == "DEV"
                }
            }    
            steps {
                sh """
                    terraform init
                """
                script {
                    if (params.operation == "Create") {
                        echo 'Dev stage create'
                         // Code for Option A
                    } else if (params.operation == "Destroy") {
                        echo 'Dev stage destroy'
                        // Code for Option B
                    }
                }
            }        
        }
        stage('UAT-stage'){
            when {
                expression {
                    params.enviornments == "UAT"
                }
            }
            steps {
                sh """
                    terraform init -reconfigure -backend-config=environments/"${params.enviornments}"/backend.tf
                """
                script {
                    if (params.operation == "Create") {
                        echo 'UAT stage create'
                         // Code for Option A
                    } else if (params.operation == "Destroy") {
                        echo 'UAT stage destroy'
                        // Code for Option B
                    }
                }
            }  
        }

        stage('Production-stage'){
            when {
                expression {
                    params.enviornments == "PROD"
                }
            }
            steps {
                sh """
                    terraform init -reconfigure -backend-config=environments/"${params.enviornments}"/backend.tf
                """
                script {
                    if (params.operation == "Create") {
                        echo 'Prod stage create'
                         // Code for Option A
                    } else if (params.operation == "Destroy") {
                        echo 'Prod stage destroy'
                        // Code for Option B
                    }
                }
            }  
        }
    }
}