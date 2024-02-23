pipeline {
    agent any
    
    stages {
        stage('SCA with OWASP Dependency Check') {
            steps {
                script {
                    // Corrected the location of the initialAdminPassword file
                    def dependencyCheckResult = dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'DP-Check'
                    echo "Dependency Check Result: ${dependencyCheckResult}"
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Corrected the SonarQube analysis
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('Sonarqube Server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker build -t rachelndah/newsread-customize customize-service/'
                    sh 'docker build -t rachelndah/newsread-news news-service/'
                }
            }
        }

        stage('Containerize And Test') {
            steps {
                script {
                    sh 'docker run -d --name customize-service -e FLASK_APP=run.py rachelndah/newsread-customize && sleep 10 && docker logs customize-service && docker stop customize-service'
                    sh 'docker run -d --name news-service -e FLASK_APP=run.py rachelndah/newsread-news && sleep 10 && docker logs news-service && docker stop news-service'
                }
            }
        }

        stage('Push Images To Dockerhub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'DockerHubPass', variable: 'DockerHubPass')]) {
                        sh "docker login -u rachelndah --password ${DockerHubPass}"
                        sh 'docker push rachelndah/newsread-news && docker push rachelndah/newsread-customize'
                    }
                }
            }
        }

        post {
            always {
                script {
                    sh 'docker rm news-service'
                    sh 'docker rm customize-service'
                }
            }
            success {
                script {
                    sh 'docker logout'
                }
            }
        }
    }
}
