pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    // environment {
    //     DOCKER_TAG = getVersion()
    // }

    stages {
        stage('Git clone') {
            steps {
             git credentialsId: 'githubId', url: 'https://github.com/lekkalaramana/sample-web-app.git'   
            }
        }
        stage('Maven Clean Package') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build . -t lekkalaramana/sample-web-application:${BUILD_NUMBER}"
            }
        }
        stage('DockerHub Push ') {
            steps {
                withCredentials([string(credentialsId: 'dockerHubPwd', variable: 'dockerHubPwd')]) {
                    sh "docker login -u lekkalaramana -p ${dockerHubPwd}"
                }
                sh "docker push lekkalaramana/sample-web-application:${BUILD_NUMBER}"
            }
        }
        // stage('Docker image deployment') {
        //     steps {
        //         sshagent(['DockerDevServerSSH']) {
        //             sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.47.64 docker rm -f samplewebappcontainer || true'
        //             sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.47.64 docker run -d -p 7070:8080 --name samplewebappcontainer lekkalaramana/sample-web-application:${BUILD_NUMBER}'
        //         }
        //     }
        // }
        stage('Docker deployment') {
            steps {
               ansiblePlaybook credentialsId: 'devserver', disableHostKeyChecking: true, extras: '-e BUILD_NUMBER=${BUILD_NUMBER}', installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml' 
            }
        }
    }
}

// def getVersion() {
//     sh returnStdout: true, script: 'git rev-parse --short HEAD'
// }
