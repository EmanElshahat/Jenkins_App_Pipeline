@Library('shared-jenkins') _

pipeline {
    agent any

    environment {
        IMAGE_NAME = "emanabosamra/kubernets-app"
        NAMESPACE  = "ivolve"
    }

    stages {

        stage('Build App') {
            steps {
                testAndBuildApp()
            }
        }

        stage('Build Docker Image') {
            steps {
                buildAndPushImage(IMAGE_NAME, BUILD_NUMBER)
            }
        }

        stage('Delete Local Docker Image') {
            steps {
                sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
            }
        }

        stage('Update deployment.yaml') {
            steps {
                sh "sed -i 's|IMAGE_PLACEHOLDER|${IMAGE_NAME}:${BUILD_NUMBER}|' k8s/deployment.yaml"
            }
        }

        stage('Push to Git') {
            steps {
                sh """
                    git config user.email "jenkins@ci.com"
                    git config user.name "Jenkins CI"
                    git add k8s/deployment.yaml
                    git commit -m "Update deployment image to ${IMAGE_NAME}:${BUILD_NUMBER}"
                    git push origin main
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
    }
}

