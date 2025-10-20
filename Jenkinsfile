pipeline {
    agent { label 'nitesh23' }

    environment {
        TF_VERSION = '1.6.0'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // ✅ Code checkout from GitHub
                git branch: 'main', url: 'https://github.com/Niteshkushwaha9595fbd/NiteshTerraform.git'
            }
        }

        stage('Install Terraform (if not installed)') {
            steps {
                // ✅ Windows-specific installation of Terraform if not present
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
                // ⚠️ Warn but don't fail build on formatting issues
                script {
                    def fmtStatus = bat(returnStatus: true, script: 'terraform.exe fmt -check -recursive')
                    if (fmtStatus != 0) {
                        echo '⚠️ Warning: Some Terraform files are not properly formatted. Please run `terraform fmt` locally.'
                    }
                }
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
                        // ✅ FIXED: Use shell variable style ($VAR), NOT env.VAR
                        "ARM_CLIENT_ID=$CLIENT_ID",
                        "ARM_CLIENT_SECRET=$CLIENT_SECRET",
                        "ARM_TENANT_ID=$TENANT_ID",
                        "ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
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
                        // ✅ FIXED again here
                        "ARM_CLIENT_ID=$CLIENT_ID",
                        "ARM_CLIENT_SECRET=$CLIENT_SECRET",
                        "ARM_TENANT_ID=$TENANT_ID",
                        "ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
                    ]) {
                        bat 'terraform.exe plan'
                    }
                }
            }
        }
    }
}
