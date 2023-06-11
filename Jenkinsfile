
pipeline {
    agent any
    environment {
        registry = "jbeanny/node-jenkins-pipeline"
        registryCredential = "dockerhub-jenkins"
    }
    stages {
        stage('Building Docker Image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":1.0.$BUILD_NUMBER"
                }
            }
        }

        stage('Deploying Docker Image') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}