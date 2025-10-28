@Library('my-shared-lib') _
pipeline {
    agent { label 'nitesh23' }

    environment {
        TF_VERSION = '1.6.0'
        TF_PLAN_FILE = 'tfplan.txt'
        TF_WORK_DIR = 'root/Prod'
        EMAIL_TO = 'niteshkushwaha9595fbd@gmail.com'
    }

    stages {

        stage('1. Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Niteshkushwaha9595fbd/NiteshTerraform.git'
            }
        }

        stage('2. Install Terraform') {
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

        stage('3. Terraform Format Check') {
            steps {
                dir("${TF_WORK_DIR}") {
                    script {
                        def fmtStatus = bat(returnStatus: true, script: 'terraform.exe fmt -check -recursive')
                        if (fmtStatus != 0) {
                            echo '⚠️ Warning: Some Terraform files are not properly formatted.'
                        }
                    }
                }
            }
        }

        stage('4. Terraform Init') {
            steps {
                dir("${TF_WORK_DIR}") {
                    withTerraformCredentials {
                        terraforminit()
                    }
                }
            }
        }

        stage('5. Terraform Validate') {
            steps {
                dir("${TF_WORK_DIR}") {
                    bat 'terraform.exe validate'
                }
            }
        }

        stage('6. Terraform Plan') {
            steps {
                dir("${TF_WORK_DIR}") {
                    withTerraformCredentials {
                        bat "terraform.exe plan > ${TF_PLAN_FILE}"
                    }
                }
            }
        }

        stage('7. Manual Approval & Email Notification') {
            steps {
                script {
                    def planFilePath = "${env.WORKSPACE}/${TF_WORK_DIR}/${TF_PLAN_FILE}"

                    if (fileExists(planFilePath)) {
                        emailext(
                            subject: "Terraform Plan Approval Needed - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                            body: """
Hello,

A new Terraform plan has been generated and is ready for your review.

▶ *Job*: ${env.JOB_NAME}  
▶ *Build Number*: ${env.BUILD_NUMBER}  
▶ *Environment*: Production  
▶ *Workspace*: ${env.WORKSPACE}

Please find the attached Terraform plan file.

Kindly review and provide approval via the Jenkins prompt.

Regards,  
Jenkins Pipeline
                            """,
                            mimeType: 'text/plain',
                            to: "${EMAIL_TO}",
                            attachmentsPattern: "${TF_WORK_DIR}/${TF_PLAN_FILE}",
                            replyTo: 'no-reply@example.com'
                        )
                    } else {
                        error("Terraform plan file not found at ${planFilePath}")
                    }
                }

                input message: '🛑 Do you approve the Terraform changes?', ok: '✅ Approve'
            }
        }

        stage('8. Terraform Apply') {
            steps {
                dir("${TF_WORK_DIR}") {
                    withTerraformCredentials {
                        bat 'az provider register --namespace Microsoft.ContainerService'
                        bat 'terraform.exe apply -auto-approve'
                    }
                }
            }
        }

        // ✅ New Cleanup Stage
        stage('9. Cleanup Workspace') {
            steps {
                dir("${TF_WORK_DIR}") {
                    echo "🧹 Cleaning up Terraform working directory..."
                    bat 'rmdir /s /q .terraform'
                    bat 'del /f /q tfplan.txt'
                    bat 'del /f /q terraform.zip'
                }
                echo "✅ Cleanup completed."
            }
        }
    }

    // Optional: Always clean workspace regardless of pipeline result
    post {
        always {
            dir("${TF_WORK_DIR}") {
                echo "🧹 Post-cleanup: Ensuring Terraform artifacts are removed..."
                bat 'rmdir /s /q .terraform'
                bat 'del /f /q tfplan.txt'
                bat 'del /f /q terraform.zip'
            }
        }
    }
}

//
// 🔐 Helper: Inject Azure credentials into environment
//
def withTerraformCredentials(Closure body) {
    withCredentials([
        usernamePassword(credentialsId: 'azure-spn-credentials', usernameVariable: 'CLIENT_ID', passwordVariable: 'CLIENT_SECRET'),
        string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID'),
        string(credentialsId: 'azure-subscription-id', variable: 'SUBSCRIPTION_ID')
    ]) {
        withEnv([
            "ARM_CLIENT_ID=${env.CLIENT_ID}",
            "ARM_CLIENT_SECRET=${env.CLIENT_SECRET}",
            "ARM_TENANT_ID=${env.TENANT_ID}",
            "ARM_SUBSCRIPTION_ID=${env.SUBSCRIPTION_ID}"
        ]) {
            body()
        }
    }
}
