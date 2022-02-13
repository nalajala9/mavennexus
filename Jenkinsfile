pipeline {
    agent any
    environment {
        dockerImage = "20152282/javaapp_$JOB_NAME:$BUILD_NUMBER"
        dockerContainerName = 'javaapp_$JOB_NAME_$BUILD_NUMBER'
    }
    tools {
        maven 'Maven'
        jdk 'JDK 1.11.*'
    }
    stages {
        stage('git checkout') {
            steps {
                git branch: 'master',
                url: 'https://github.com/nalajala9/mavennexus.git'
                sh 'ls -al'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true'
                sh 'ls -al'
            }
        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'SonarQube Scanner' // the name you have given the Sonar Scanner (Global Tool Configuration
            }
            steps {
                withSonarQubeEnv(installationName: 'SonarServer') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
         stage('upload jar file to nexus ') {
            steps {
                nexusArtifactUploader artifacts: [
                    [
                        artifactId: 'github-action-maven-tutorial', 
                        classifier: '', 
                        file: 'target/github-action-maven-tutorial-1.0-SNAPSHOT.jar', 
                        type: 'jar']
                ], 
                    credentialsId: 'nexus', 
                    groupId: 'org.kth', 
                    nexusUrl: '13.59.204.213:8081', 
                    nexusVersion: 'nexus3', 
                    protocol: 'http', 
                    repository: 'http://13.59.204.213:8081/repository/javaapp/', 
                    version: '1.0-SNAPSHOT'         
            }
        }
        
        stage('Build Docker Image ') {
            steps {
                sh "docker build  -t ${dockerImage} ."
            }
        }

        stage('Docker Run') {
            steps {
                sh "docker run -dit --name ${dockerContainerName} -p 8000:80 ${dockerImage}"
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
