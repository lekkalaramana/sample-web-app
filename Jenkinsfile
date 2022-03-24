pipeline {
    agent any
    stages {
        stage('Git clone'){
            steps {
                git credentialsId: 'github', url: 'https://github.com/lekkalaramana/sample-web-app.git'
            }
        }
        stage('Maven clean package'){
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Build docker image'){
            steps {
                sh 'docker build -t lekkalaramana/java-web-application:${BUILD_NUMBER} .'
            }
        }
        stage('Docker push') {
            steps {
                withCredentials([string(credentialsId: 'dockerHubPwd', variable: 'dockerHubPwd')]) {
    		        sh 'docker login -u lekkalaramana -p ${dockerHubPwd}'
		        }
		        sh "docker push lekkalaramana/java-web-application:${BUILD_NUMBER}"
            }
        }
        stage('Docker image deployment') {
            steps {
                ansiblePlaybook credentialsId: 'sshConnection', disableHostKeyChecking: true, extras: '-e BUILD_NUMBER=${BUILD_NUMBER}', installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
    }
}
