pipeline {
    agent { label 'nitesh23' }

    environment {
        TF_VERSION = "1.5.0"
        TF_WORKING_DIR = "C:\\Terraform\\Prod"  // Windows path (double backslashes)
        TF_ZIP = "terraform_${TF_VERSION}_windows_amd64.zip"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Terraform') {
            steps {
                bat '''
                where terraform >nul 2>nul
                if %ERRORLEVEL% NEQ 0 (
                    echo Terraform not found. Installing...
                    curl -O https://releases.hashicorp.com/terraform/%TF_VERSION%/%TF_ZIP%
                    tar -xf %TF_ZIP%
                    move terraform.exe C:\\Windows\\System32\\terraform.exe
                )
                terraform version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TF_WORKING_DIR}") {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir("${env.TF_WORKING_DIR}") {
                    bat 'terraform fmt -check'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${env.TF_WORKING_DIR}") {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.TF_WORKING_DIR}") {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                dir("${env.TF_WORKING_DIR}") {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Terraform pipeline executed successfully on Windows Agent!'
        }
        failure {
            echo '❌ Pipeline failed! Please check the logs.'
        }
        always {
            echo '📄 Pipeline execution completed.'
        }
    }
}
