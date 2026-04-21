pipeline {
    agent any

    environment {
        AWS_REGION               = 'us-east-1'
        AWS_ACCOUNT_ID           = '113645088585'

        ECR_FRONTEND_REPO        = 'frontend'
        ECR_BACKEND_REPO         = 'backend'

        FRONTEND_IMAGE_REPO      = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_FRONTEND_REPO}"
        BACKEND_IMAGE_REPO       = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_BACKEND_REPO}"

        IMAGE_TAG                = "${BUILD_NUMBER}"

        ECS_CLUSTER              = 'techchallenge1-cluster'
        ECS_FRONTEND_SERVICE     = 'techchallenge1-frontend-svc'
        ECS_BACKEND_SERVICE      = 'techchallenge1-backend-svc'

        ECS_FRONTEND_TASK_FAMILY = 'techchallenge1-frontend'
        ECS_BACKEND_TASK_FAMILY  = 'techchallenge1-backend'
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    set -eux

                    docker build -t ${FRONTEND_IMAGE_REPO}:${IMAGE_TAG} ./frontend
                    docker build -t ${BACKEND_IMAGE_REPO}:${IMAGE_TAG} ./backend
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    set -eux

                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin \
                    ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    set -eux

                    docker push ${FRONTEND_IMAGE_REPO}:${IMAGE_TAG}
                    docker push ${BACKEND_IMAGE_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Register New Frontend Task Definition') {
            steps {
                sh '''
                    set -eux

                    aws ecs describe-task-definition \
                      --task-definition ${ECS_FRONTEND_TASK_FAMILY} \
                      --region ${AWS_REGION} \
                      > frontend-task-def.json

                    jq '.taskDefinition
                        | del(
                            .taskDefinitionArn,
                            .revision,
                            .status,
                            .requiresAttributes,
                            .compatibilities,
                            .registeredAt,
                            .registeredBy,
                            .deregisteredAt
                          )
                        | .containerDefinitions |= map(
                            if .name == "frontend"
                            then .image = "'"${FRONTEND_IMAGE_REPO}:${IMAGE_TAG}"'"
                            else .
                            end
                          )' \
                        frontend-task-def.json > frontend-task-def-new.json

                    aws ecs register-task-definition \
                      --cli-input-json file://frontend-task-def-new.json \
                      --region ${AWS_REGION} \
                      > frontend-task-def-registered.json

                    FRONTEND_TASK_DEF_ARN=$(jq -r '.taskDefinition.taskDefinitionArn' frontend-task-def-registered.json)
                    echo "${FRONTEND_TASK_DEF_ARN}" > frontend_task_def_arn.txt
                '''
            }
        }

        stage('Register New Backend Task Definition') {
            steps {
                sh '''
                    set -eux

                    aws ecs describe-task-definition \
                      --task-definition ${ECS_BACKEND_TASK_FAMILY} \
                      --region ${AWS_REGION} \
                      > backend-task-def.json

                    jq '.taskDefinition
                        | del(
                            .taskDefinitionArn,
                            .revision,
                            .status,
                            .requiresAttributes,
                            .compatibilities,
                            .registeredAt,
                            .registeredBy,
                            .deregisteredAt
                          )
                        | .containerDefinitions |= map(
                            if .name == "backend"
                            then .image = "'"${BACKEND_IMAGE_REPO}:${IMAGE_TAG}"'"
                            else .
                            end
                          )' \
                        backend-task-def.json > backend-task-def-new.json

                    aws ecs register-task-definition \
                      --cli-input-json file://backend-task-def-new.json \
                      --region ${AWS_REGION} \
                      > backend-task-def-registered.json

                    BACKEND_TASK_DEF_ARN=$(jq -r '.taskDefinition.taskDefinitionArn' backend-task-def-registered.json)
                    echo "${BACKEND_TASK_DEF_ARN}" > backend_task_def_arn.txt
                '''
            }
        }

        stage('Update ECS Services') {
            steps {
                sh '''
                    set -eux

                    FRONTEND_TASK_DEF_ARN=$(cat frontend_task_def_arn.txt)
                    BACKEND_TASK_DEF_ARN=$(cat backend_task_def_arn.txt)

                    aws ecs update-service \
                      --cluster ${ECS_CLUSTER} \
                      --service ${ECS_FRONTEND_SERVICE} \
                      --task-definition ${FRONTEND_TASK_DEF_ARN} \
                      --force-new-deployment \
                      --region ${AWS_REGION}

                    aws ecs update-service \
                      --cluster ${ECS_CLUSTER} \
                      --service ${ECS_BACKEND_SERVICE} \
                      --task-definition ${BACKEND_TASK_DEF_ARN} \
                      --force-new-deployment \
                      --region ${AWS_REGION}
                '''
            }
        }
    }

    post {
        success {
            echo "Images pushed and ECS services updated successfully."
        }
        failure {
            echo "Pipeline failed. Check console output."
        }
    }
}