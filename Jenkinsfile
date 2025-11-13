pipeline {
    agent any

    environment {
        TF_VERSION = "1.9.8"
        TF_WORK_DIR = "terraform"
        TF_PLAN_FILE = "tfplan.txt"
        EMAIL_TO = "team@example.com"
    }

    stages {

        stage('2. Install Terraform') {
            steps {
                sh '''
                 # ensure unzip is available
            if ! command -v unzip &> /dev/null; then
                echo "📦 Installing unzip..."
                apt-get update -y && apt-get install -y unzip
            fi

            # download terraform if not present
            if ! command -v terraform &> /dev/null; then
                echo "Terraform not found, downloading..."
                curl -o terraform.zip https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip
                unzip -o terraform.zip
                chmod +x terraform
                echo "export PATH=$PATH:$(pwd)" >> ~/.bashrc
                export PATH=$PATH:$(pwd)
            fi

            terraform version
        '''
            }
        }

        stage('3. Terraform Format Check') {
            steps {
                dir("${TF_WORK_DIR}") {
                    script {
                        def fmtStatus = sh(returnStatus: true, script: 'terraform fmt -check -recursive')
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
                    sh 'terraform validate'
                }
            }
        }

        stage('6. Terraform Plan') {
            steps {
                dir("${TF_WORK_DIR}") {
                    withTerraformCredentials {
                        sh "terraform plan > ${TF_PLAN_FILE}"
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
                        sh '''
                            az provider register --namespace Microsoft.ContainerService || true
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('9. Cleanup Workspace') {
            steps {
                dir("${TF_WORK_DIR}") {
                    echo "🧹 Cleaning up Terraform working directory..."
                    sh '''
                        rm -rf .terraform
                        rm -f tfplan.txt
                        rm -f terraform.zip
                    '''
                }
                echo "✅ Cleanup completed."
            }
        }
    }

    post {
        always {
            dir("${TF_WORK_DIR}") {
                echo "🧹 Post-cleanup: Ensuring Terraform artifacts are removed..."
                sh '''
                    rm -rf .terraform
                    rm -f tfplan.txt
                    rm -f terraform.zip
                '''
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
