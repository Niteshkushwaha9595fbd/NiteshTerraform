pipeline {
    agent { label 'nitesh23' }

    environment {
        TF_VERSION = '1.6.0'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Niteshkushwaha9595fbd/NiteshTerraform.git'
            }
        }

        stage('Install Terraform (if not installed)') {
            steps {
                bat '''
                    IF NOT EXIST terraform.exe (
                        echo Terraform not found, downloading...
                        curl -o terraform.zip https://releases.hashicorp.com/terraform/%TF_VERSION%/terraform_%TF_VERSION%_windows_amd64.zip
                        powershell -Command "Expand-Archive -Path terraform.zip -DestinationPath . -Force"
                    )
                    terraform.exe -version
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                bat 'terraform.exe fmt -check -recursive'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'azure-client-id', variable: 'CLIENT_ID'),
                    string(credentialsId: 'azure-client-secret', variable: 'CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID'),
                    string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID')
                ]) {
                    withEnv([
                        "ARM_CLIENT_ID=${env.CLIENT_ID}",
                        "ARM_CLIENT_SECRET=${env.CLIENT_SECRET}",
                        "ARM_TENANT_ID=${env.TENANT_ID}",
                        "ARM_SUBSCRIPTION_ID=${env.SUBSCRIPTION_ID}"
                    ]) {
                        bat 'terraform.exe init'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform.exe validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'azure-client-id', variable: 'CLIENT_ID'),
                    string(credentialsId: 'azure-client-secret', variable: 'CLIENT_SECRET'),
                    string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID'),
                    string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID')
                ]) {
                    withEnv([
                        "ARM_CLIENT_ID=${env.CLIENT_ID}",
                        "ARM_CLIENT_SECRET=${env.CLIENT_SECRET}",
                        "ARM_TENANT_ID=${env.TENANT_ID}",
                        "ARM_SUBSCRIPTION_ID=${env.SUBSCRIPTION_ID}"
                    ]) {
                        bat 'terraform.exe plan'
                    }
                }
            }
        }
    }
}
