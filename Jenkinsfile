pipeline {
     agent any

    environment {
        TF_VERSION = '1.6.0' // Optional, agar install karna ho
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main' , url: 'https://github.com/Niteshkushwaha9595fbd/NiteshTerraform.git' // Replace with your repo URL
            }
        }

        stage('Install Terraform (if not installed)') {
            steps {
                sh '''
                    if ! command -v terraform &> /dev/null; then
                        echo "Terraform not found, installing..."
                        curl -o terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                        unzip terraform.zip
                        sudo mv terraform /usr/local/bin/
                    fi
                    terraform -version
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check -recursive'
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
                        "ARM_CLIENT_ID=${CLIENT_ID}",
                        "ARM_CLIENT_SECRET=${CLIENT_SECRET}",
                        "ARM_TENANT_ID=${TENANT_ID}",
                        "ARM_SUBSCRIPTION_ID=${SUBSCRIPTION_ID}"
                    ]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
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
                        "ARM_CLIENT_ID=${CLIENT_ID}",
                        "ARM_CLIENT_SECRET=${CLIENT_SECRET}",
                        "ARM_TENANT_ID=${TENANT_ID}",
                        "ARM_SUBSCRIPTION_ID=${SUBSCRIPTION_ID}"
                    ]) {
                        sh 'terraform plan'
                    }
                }
            }
        }
    }
}
