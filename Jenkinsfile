pipeline {
    agent any

    environment {
        IMAGE_NAME = "emanabosamra/kubernets-app"
    }

    stages {
        stage('Unit Test') {
            steps {
                echo 'Running Unit Tests with Maven...'
                sh 'mvn test'
            }
        }

        stage('Build App') {
            steps {
                echo 'Building App with Maven...'
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker Image ${IMAGE_NAME}:${BUILD_NUMBER}"
                script {
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Logging in to Docker Hub and pushing ${IMAGE_NAME}:${BUILD_NUMBER}"
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Delete Local Docker Image') {
            steps {
                echo "Deleting local Docker image ${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
            }
        }

        stage('Update deployment.yaml') {
            steps {
                echo 'Updating deployment.yaml with new image...'
                sh "sed -i 's|IMAGE_PLACEHOLDER|${IMAGE_NAME}:${BUILD_NUMBER}|' deployment.yaml"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes cluster...'
                sh 'kubectl apply -f deployment.yaml -n ivolve'
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

