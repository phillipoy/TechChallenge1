# DevOps Code Challenge 1

## Overview

This project demonstrates a full DevOps workflow for deploying a containerized full-stack application on AWS using Terraform, Docker, ECS Fargate, and Jenkins.

The system includes:
- React frontend
- Node.js backend
- AWS ECS (Fargate)
- AWS ECR
- Application Load Balancer (ALB)
- Jenkins CI/CD pipeline
- Terraform (Infrastructure as Code)

---

## Architecture

User → ALB → Frontend (ECS) → Backend (ECS)

- Frontend handles UI
- Backend returns a GUID
- ALB routes /api traffic to backend

---

## Local Setup

### Prerequisites

- Node.js
- npm
- Git
- Docker

---

### Run Locally (Without Docker)

Backend:

cd backend
npm install
npm start

Backend runs at:
http://localhost:8080/api

Frontend:

cd frontend
npm install
npm start

Frontend runs at:
http://localhost:3000

---

## Docker Setup

### Run with Docker Compose

docker compose up --build

This will:
- Build frontend and backend images
- Start both services
- Connect them together automatically

---

### Access Locally

Frontend:
http://localhost:3000

Backend:
http://localhost:8080/api

---

### Important Note (Local vs AWS)

When running locally, the frontend communicates with the backend using localhost-based URLs.

When deployed to AWS, the frontend must call the backend through the Application Load Balancer using:

http://<ALB-DNS>/api

In the deployed environment, localhost does not refer to the ECS backend.

The frontend and backend config.js files may need to be updated when switching between local development and AWS deployment. Local development can use localhost, while the deployed version should use the ALB DNS name so requests reach the backend correctly.

---

## Terraform Deployment Guide

### Prerequisites

- AWS CLI configured (aws configure)
- Terraform installed

---

### Deploy Infrastructure

cd terraform
terraform init
terraform apply

This creates:
- VPC
- Public and private subnets
- ALB
- ECS Cluster (Fargate)
- ECS Services (frontend + backend)
- ECR repositories
- Security groups
- Autoscaling configuration

---

## Jenkins Setup and Pipeline

### Jenkins Server Setup (EC2)

Jenkins is hosted on an EC2 instance.

### Install Dependencies

sudo apt update
sudo apt install docker.io -y
sudo apt install awscli -y
sudo apt install jq -y

### Jenkins Configuration

1. Create a Pipeline Job
2. Select "Pipeline from SCM"
3. Set:
   - GitHub repository URL
   - Branch: main
   - Script path: Jenkinsfile

### Pipeline Workflow

1. Checkout code from GitHub
2. Build Docker images
3. Login to AWS ECR
4. Push images to ECR
5. Register ECS task definitions
6. Update ECS services

---

## Jenkins Infrastructure Details

- EC2 Instance Type: m7i-flex.large
- OS: Ubuntu
- Security Group:
  - Port 22 (SSH)
  - Port 8080 (Jenkins UI)
  - Outbound: Allow all
- IAM Role Permissions:
  - AmazonEC2ContainerRegistryPowerUser
  - AmazonECS_FullAccess

---

## Load Balancer Routing

- / → Frontend
- /api and /api/* → Backend

---

## Fargate Scaling and Load Testing

### Autoscaling Configuration

- Minimum tasks: 1
- Maximum tasks: 4
- Target CPU: 50%

### Load Testing with Siege

Frontend test:

siege -c 250 -t 2M http://<ALB-DNS>/

Backend test:

siege -c 250 -t 2M http://<ALB-DNS>/api

### Results

- Frontend scaled from 1 → 2 tasks
- Backend remained at 1 task due to lightweight processing
- Autoscaling successfully validated

---

## Application Output

SUCCESS <GUID>

Example:

SUCCESS 958f3127-aae6-42fe-a9ac-ee9816bcc60c

---

## Key Learnings

- Built production-style cloud architecture using ECS Fargate
- Implemented CI/CD pipeline with Jenkins
- Used Terraform for Infrastructure as Code
- Configured ALB path-based routing
- Validated autoscaling using load testing

---

## Future Improvements

- Add HTTPS with AWS ACM
- Add GitHub webhooks for Jenkins automation
- Use environment variables instead of hardcoding API URLs
- Add monitoring dashboards with CloudWatch
- Add custom domain using Route 53

---

## Author

Phillip Oyediran 