pipeline {
    agent any
    environment {
        dockerImage = "20152282/javaapp_$JOB_NAME:$BUILD_NUMBER"
        dockerContainerName = 'javaapp_$JOB_NAME_$BUILD_NUMBER'
    }
    tools {
        maven 'Maven'
        jdk 'JDK 1.8.*'
    }
    stages {
        stage('git checkout') {
            steps {
                git branch: 'master',
                url: 'https://github.com/nalajala9/github-action-maven-example-start.git'
                sh 'ls -al'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true'
                sh 'ls -al'
            }
        }

        stage('Sonar Testing') {
            steps {
                sh 'mvn sonar:sonar \
                -Dsonar.projectKey=test \
                -Dsonar.host.url=http://3.144.255.88:9000/ \
                -Dsonar.login=fb5e9f638cede98b9355b07c4ab09a766b59ff03'
            }
        }
        stage('Build Docker Image ') {
            steps {
                sh "docker build  -t ${dockerImage} ."
            }
        }

        stage('Docker Run') {
            steps {
                sh "docker run -dit --name ${dockerContainerName} ${dockerImage}"
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerPWD')]) {
                    sh "docker login -u 20152282 -p ${dockerPWD}"
                }
                sh "docker push ${dockerImage}"
            }
        }
    }
}
