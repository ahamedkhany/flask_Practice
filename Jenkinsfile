pipeline {

    agent any

    environment {
        IMAGE_NAME = "flask-app"
        CONTAINER_NAME = "flask-container"
        MONGO_URI = credentials('mongo-uri')
        SECRET_KEY = credentials('secret-key')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                . venv/bin/activate
                pytest -v
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true

                docker run -d \
                  --name ${CONTAINER_NAME} \
                  -p 5000:5000 \
                  -e MONGO_URI="$MONGO_URI" \
                  -e SECRET_KEY="$SECRET_KEY" \
                  ${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }
    }
}
post {

    success {
        emailext(
            subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
Hello,

The Jenkins pipeline completed successfully.

Job Name   : ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
Build Status: SUCCESS

Build URL:
${env.BUILD_URL}

Regards,
Jenkins CI/CD
""",
            to: "ahamedkhany1@gmail.com"
        )
    }

    failure {
        emailext(
            subject: "FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: """
Hello,

The Jenkins pipeline has failed.

Job Name   : ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
Build Status: FAILED

Please check the console output for more details.

Build URL:
${env.BUILD_URL}

Regards,
Jenkins CI/CD
""",
            to: "ahamedkhany1@gmail.com"
        )
    }

    always {
        echo "Pipeline execution completed."
    }
}