@Library('shared-jenkins') _

pipeline {
    agent any

    environment {
        IMAGE_NAME = "emanabosamra/kubernets-app"
        NAMESPACE  = "ivolve"
    }

    stages {

        stage('Test & Build App') {
            steps {
                testAndBuildApp()
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                buildAndPushImage(IMAGE_NAME, BUILD_NUMBER)
            }
        }

        stage('Scan Image') {
            steps {
                echo 'Scanning Docker image using Docker Scout'
                sh """
                docker scout quickview ${IMAGE_NAME}:${BUILD_NUMBER} || true
                """
            }
        }

        stage('Delete Local Docker Image') {
            steps {
                echo 'Deleting local Docker image'
                sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
            }
        }

        stage('Update deployment.yaml') {
            steps {
                echo 'Updating deployment.yaml with new image'
                sh "sed -i 's|IMAGE_PLACEHOLDER|${IMAGE_NAME}:${BUILD_NUMBER}|' deployment.yaml"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                deployK8s(NAMESPACE)
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished (always runs)'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

