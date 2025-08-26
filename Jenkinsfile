pipeline {
    agent any

    environment {
        DOCKER_USER = 'panditaditya1798'
        IMAGE_REPO  = 'panditaditya1798/nextjs-app'
        IMAGE_TAG   = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "📦 Checking out code from GitHub..."
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: 'main']],
                        userRemoteConfigs: [[url: 'https://github.com/adityapandit1798/test-assignment-pumpkin.git']]  // ✅ Fixed: Removed extra spaces
                    ])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🏗️ Building Docker image: ${IMAGE_REPO}:${IMAGE_TAG}"
                    sh '''
                        docker build -t ${IMAGE_REPO}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    echo "🔐 Logging in to Docker Hub..."
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "📤 Pushing image to Docker Hub..."
                    sh '''
                        docker push ${IMAGE_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    echo "🚀 Deploying container on EC2..."
                    sh '''
                        set -e  # Fail on error

                        echo "Stopping any running container..."
                        docker stop nextjs-app || true

                        echo "Removing old container..."
                        docker rm nextjs-app || true

                        echo "Running new container..."
                        docker run -d \\
                          --name nextjs-app \\
                          -p 3000:3000 \\
                          --restart unless-stopped \\
                          ${IMAGE_REPO}:${IMAGE_TAG}

                        echo "✅ Deployment successful! App running on port 3000"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline succeeded! Your app is live at: http://<your-ec2-public-ip>:3000"
        }
        failure {
            echo "❌ Pipeline failed. Check the logs above."
        }
        always {
            // ✅ Fixed: Jenkins requires at least one step in 'always'
            echo "🏁 Pipeline completed with status: ${currentBuild.result}"
        }
    }
}