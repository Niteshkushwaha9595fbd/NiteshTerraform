pipeline {
    agent { label 'nitesh23' }

    environment {
        TF_VERSION = '1.6.0'
        TF_PLAN_FILE = 'tfplan.txt'
        EMAIL_TO = 'niteshkushwaha9595fbd@gmail.com'  // 🔁 CHANGE THIS
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Niteshkushwaha9595fbd/NiteshTerraform.git'
            }
        }

        stage('Install Terraform') {
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
                dir('root/Prod') {
                    script {
                        def fmtStatus = bat(returnStatus: true, script: 'terraform.exe fmt -check -recursive')
                        if (fmtStatus != 0) {
                            echo '⚠️ Warning: Some Terraform files are not properly formatted.'
                        }
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('root/Prod') {
                    withCredentials([
                        usernamePassword(credentialsId: 'azure-spn-credentials', usernameVariable: 'CLIENT_ID', passwordVariable: 'CLIENT_SECRET'),
                        string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID'),
                        string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID')
                    ]) {
                        withEnv([
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
        }

        stage('Terraform Validate') {
            steps {
                dir('root/Prod') {
                    bat 'terraform.exe validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('root/Prod') {
                    withCredentials([
                        usernamePassword(credentialsId: 'azure-spn-credentials', usernameVariable: 'CLIENT_ID', passwordVariable: 'CLIENT_SECRET'),
                        string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID'),
                        string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID')
                    ]) {
                        withEnv([
                            "ARM_CLIENT_ID=$CLIENT_ID",
                            "ARM_CLIENT_SECRET=$CLIENT_SECRET",
                            "ARM_TENANT_ID=$TENANT_ID",
                            "ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
                        ]) {
                            bat "terraform.exe plan > ${env.TF_PLAN_FILE}"
                        }
                    }
                }
            }
        }

        stage('Manual Validation & Email') {
            steps {
                script {
                    emailext(
                        subject: "Terraform Plan Approval Needed",
                        body: """
                            Hello,

                            Please review the attached Terraform plan for approval.

                            Regards,
                            DevOps Pipeline
                        """,
                        to: "${EMAIL_TO}",
                        attachmentsPattern: "**/root/Prod/${TF_PLAN_FILE}"
                    )
                }
                input message: 'Do you approve the Terraform changes?', ok: 'Approve'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('root/Prod') {
                    withCredentials([
                        usernamePassword(credentialsId: 'azure-spn-credentials', usernameVariable: 'CLIENT_ID', passwordVariable: 'CLIENT_SECRET'),
                        string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID'),
                        string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID')
                    ]) {
                        withEnv([
                            "ARM_CLIENT_ID=$CLIENT_ID",
                            "ARM_CLIENT_SECRET=$CLIENT_SECRET",
                            "ARM_TENANT_ID=$TENANT_ID",
                            "ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
                        ]) {
                            bat 'terraform.exe apply -auto-approve'
                        }
                    }
                }
            }
        }
    }
}
