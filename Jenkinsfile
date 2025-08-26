// Jenkinsfile

pipeline {
    agent { label 'docker-node' }  // Run everything on remote Docker host

    environment {
        DOCKERHUB_USERNAME = 'adityapandit1798'  // ← Replace if different
        DOCKERHUB_REPO     = 'adityapandit1798/nextjs-app'
        IMAGE_TAG          = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "📦 Checking out code..."
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🏗️  Building Docker image: ${DOCKERHUB_REPO}:${IMAGE_TAG}"
                    sh 'docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .'
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    echo "🔐 Logging in to DockerHub..."
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh 'echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "📤 Pushing image to DockerHub..."
                    sh 'docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    echo "🚀 Deploying container..."
                    sh '''
                        docker stop nextjs-app || true
                        docker rm nextjs-app || true
                        docker run -d -p 3000:3000 --name nextjs-app \
                            --restart unless-stopped \
                            ${DOCKERHUB_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! App running at http://<your-ec2-ip>:3000"
        }
        failure {
            echo "❌ Deployment failed. Check logs in Jenkins."
        }
        always {
            // Optional: Send notification
        }
    }
}