pipeline {
    agent any
    environment {
        AWS_REGION= 'ap-south-1'
        ECR_REPO= '607709788195.dkr.ecr.ap-south-1.amazonaws.com/spring-mongo-app'
        IMAGE_TAG= "${BUILD_NUMBER}"
        }
    tools {
        maven 'maven3.9.15'
    }
    stages {
        stage('git clone') {
            steps {
               git 'https://github.com/mirzatechno/Springboot-Mongo-Application.git'
            } 
        }
        stage('maven build'){
            steps{
                sh "mvn clean package"
            }
        }
         stage('sonarqube report '){
            steps{
                sh "mvn sonar:sonar"
            }
        }
        stage('Docker Build'){
            steps{
                sh "docker build -t $ECR_REPO:$IMAGE_TAG ."
            }
        }
        stage('ECR login'){
            steps{
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin 607709788195.dkr.ecr.ap-south-1.amazonaws.com
                '''
            }
        }
        stage('Docker push'){
            steps{
                sh "docker push $ECR_REPO:$IMAGE_TAG"
            }
        }
        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks update-kubeconfig \
                --region $AWS_REGION \
                --name my-cluster1

                # Replace image in deployment
                sed -i "s|IMAGE_PLACEHOLDER|$ECR_REPO:$IMAGE_TAG|g" SpringBootMongo.yaml

                # Apply resources in order
                kubectl apply -f SpringBootMongo.yaml
                kubectl apply -f ingress.yaml


                # Verify rollout
                kubectl rollout status deployment/springboot-deployment -n production
                '''
            }
        }

        
    } //stages closing
} //pipeline close
