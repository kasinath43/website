
pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building Abode Software website'

                sh '''
                    docker build -t abode-webapp:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Testing Abode Software website'

                sh '''
                    docker network inspect abode-ci >/dev/null 2>&1 || docker network create abode-ci

                    docker network connect abode-ci jenkins 2>/dev/null || true

                    docker rm -f abode-test 2>/dev/null || true

                    docker run -d \
                        --name abode-test \
                        --network abode-ci \
                        abode-webapp:${BUILD_NUMBER}

                    trap 'docker rm -f abode-test 2>/dev/null || true' EXIT

                    sleep 5

                    curl -f http://abode-test
                '''
            }
        }

        stage('Production') {
            when {
                branch 'master'
            }

            steps {
                echo 'Deploying Abode Software to production'

                sh '''
                    docker rm -f abode-webapp-container 2>/dev/null || true

                    docker run -d \
                        --name abode-webapp-container \
                        -p 8080:80 \
                        abode-webapp:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the Console Output.'
        }
    }
}
