// Jenkinsfile

pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'adityapandit1798'
        DOCKERHUB_REPO     = 'adityapandit1798/nextjs-app'
        IMAGE_TAG          = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker stop nextjs-app || true
                    docker rm nextjs-app || true
                    docker run -d -p 3000:3000 --name nextjs-app --restart unless-stopped ${DOCKERHUB_REPO}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}