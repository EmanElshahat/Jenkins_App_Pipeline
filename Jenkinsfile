@Library('shared-jenkins') _

pipeline {
    agent any

    environment {
        IMAGE_NAME = "emanabosamra/kubernets-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        GIT_REPO   = "https://github.com/Ibrahim-Adel15/Jenkins_App.git"
        GIT_BRANCH = "main"
    }

    stages {

        stage('Build App') {
            steps {
                testAndBuildApp()
            }
        }

        stage('Build Docker Image') {
            steps {
                buildDockerImage("${IMAGE_NAME}:${IMAGE_TAG}")
            }
        }

        stage('Push Docker Image') {
            steps {
                pushDockerImage("${IMAGE_NAME}:${IMAGE_TAG}")
            }
        }

        stage('Delete Local Docker Image') {
            steps {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
            }
        }

        stage('Update deployment.yaml') {
            steps {
                sh """
                sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|' deployment.yaml
                """
            }
        }

        stage('Commit & Push Git Changes') {
            steps {
                sh """
                git config user.email "jenkins@ci.com"
                git config user.name "Jenkins CI"

                git add deployment.yaml
                git commit -m "Update image to ${IMAGE_NAME}:${IMAGE_TAG}" || echo "No changes to commit"
                git push origin ${GIT_BRANCH}
                """
            }
        }
    }

    post {
        success {
            echo "Git updated successfully — ArgoCD will sync automatically 🚀"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
