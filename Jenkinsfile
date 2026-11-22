pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t abode-webapp:${BUILD_NUMBER} .'
            }
        }

        stage('Test') {
            steps {
                sh '''
                    docker rm -f abode-test 2>/dev/null || true
                    docker run -d --name abode-test -p 18080:80 abode-webapp:${BUILD_NUMBER}
                    sleep 5
                    curl -f http://localhost:18080
                    docker rm -f abode-test
                '''
            }
        }

        stage('Production') {
            when {
                expression { env.GIT_BRANCH == 'origin/master' }
            }
            steps {
                sh '''
                    docker rm -f abode-webapp-container || true
                    docker run -d --name abode-webapp-container -p 8080:80 abode-webapp:${BUILD_NUMBER}
                '''
            }
        }
    }
}
