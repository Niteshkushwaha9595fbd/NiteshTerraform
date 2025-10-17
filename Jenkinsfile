pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('d4ced0e9-777b-4a6b-ac62-a7360d700277')
        ARM_CLIENT_SECRET   = credentials('6d821ddf-5949-451a-a909-c4b57053f977')
        ARM_TENANT_ID       = credentials('e270fd69-de2c-4331-b82d-ecdd35b46120')
        ARM_SUBSCRIPTION_ID = credentials('bfa25a35-e77a-47a6-8d20-5557ab211ef7')

        // TF_VAR_environment = 'dev' // Can be parameterized for stage/prod
        // BACKEND_RESOURCE_GROUP = 'myrg'
        // BACKEND_STORAGE_ACCOUNT = 'mystorageacct'
        // BACKEND_CONTAINER_NAME = 'tfstate'
        // BACKEND_KEY = "dev.terraform.tfstate"
    }

    parameters {
        booleanParam(name: 'APPLY_CHANGES', defaultValue: false, description: 'Apply Terraform changes after plan?')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                terraform init \
                  -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
                  -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
                  -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
                  -backend-config="key=${BACKEND_KEY}"
                '''
            }
        }

        stage('Terraform Format and Validate') {
            steps {
                sh '''
                terraform fmt -check
                terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Approval Before Apply') {
            when {
                expression { return params.APPLY_CHANGES }
            }
            steps {
                input message: "Approve applying changes to Azure for ${TF_VAR_environment}?", ok: "Approve"
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.APPLY_CHANGES }
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            echo 'Terraform pipeline completed.'
        }
    }
}
