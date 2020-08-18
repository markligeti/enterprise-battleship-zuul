pipeline {
    agent any
    environment {
        BUILDVAR = "var_build_number"
        TOKEN = credentials("KubernetesToken")
        K8S_URL = credentials("URL")
        JSON = "zuul-deployment.json"
        DOCKER_REPO = "safranek/enterprise-battleship-zuul"
    }
    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/markligeti/enterprise-battleship-zuul.git', branch: "${env.BRANCH_NAME}"
            }
        }
        stage('Build') {
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }
        stage('Create Container') {
            steps {
                sh "docker build -t ${DOCKER_REPO}:latest ."
                sh "docker build -t ${DOCKER_REPO}:${BUILD_NUMBER} ."
            }
        }
        stage('Deployment') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                sh "docker push ${DOCKER_REPO}:latest"
                sh "docker push ${DOCKER_REPO}:${BUILD_NUMBER}"
                sh "sed -i -e 's#${BUILDVAR}#${BUILD_NUMBER}#' ${JSON}"
                sh "curl https://${K8S_URL}:6443/apis/apps/v1/namespaces/default/deployments/zuul-gateway \
                -k -H 'Content-Type: application/json' -H 'Authorization: Bearer ${TOKEN}' --data @${JSON} --request PUT"
                }
            }
        }
    }
}


