@Library('shared-jenkins') _

pipeline {
    agent any

    environment {
        IMAGE_NAME = "emanabosamra/kubernets-app"
    }

    stages {

        stage('Select Namespace') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        env.NAMESPACE = 'dev'
                    }
                    else if (env.BRANCH_NAME == 'stag') {
                        env.NAMESPACE = 'stag'
                    }
                    else if (env.BRANCH_NAME == 'prod'|| env.BRANCH_NAME == 'main') {
                        env.NAMESPACE = 'prod'
                    }
                    else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                    }
                    echo "Deploying branch ${env.BRANCH_NAME} to namespace ${env.NAMESPACE}"
                }
            }
        }

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

        stage('Deploy to Kubernetes') {
            steps {
                deployK8s(NAMESPACE)
            }
        }
    }

    post {
        always {
            echo "Deployment finished for ${env.BRANCH_NAME} → ${env.NAMESPACE}"
        }
    }
}

