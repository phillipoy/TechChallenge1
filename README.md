# Tech Challenge 1  
## Full DevOps Deployment with Jenkins, Terraform, ECS Fargate, and EC2

## Project Overview

This branch demonstrates a complete end to end DevOps deployment using Jenkins for CI/CD automation, Terraform for Infrastructure as Code, Docker for containerization, and Amazon ECS with Fargate for application hosting.

The application consists of a frontend and backend service. Both services are containerized, pushed to Amazon ECR, and deployed through a Jenkins pipeline hosted on a dedicated EC2 server.

This `main` branch is specifically focused on the Jenkins based CI/CD workflow.

---

## Branch Purpose

- `main` branch = Jenkins CI/CD pipeline  
- `gitops` branch = GitHub Actions CI/CD pipeline

Both branches deploy the same project using different automation tools.

---

## Core Technologies Used

- AWS EC2
- Amazon ECS
- AWS Fargate
- Amazon ECR
- Application Load Balancer
- Terraform
- Jenkins
- Docker
- GitHub
- CloudWatch
- IAM
- Ubuntu Linux

---

## Solution Architecture

GitHub Repository  
↓  
Jenkins Pipeline on EC2  
↓  
Build Frontend and Backend Docker Images  
↓  
Push Images to Amazon ECR  
↓  
Update ECS Task Definitions  
↓  
Deploy Containers to ECS Fargate  
↓  
Serve Traffic Through Application Load Balancer

---

## Infrastructure Provisioned with Terraform

Terraform was used to deploy and manage all AWS resources.

### Networking

- Custom VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables

### Security

- Security Groups for ALB
- Security Groups for ECS Tasks
- Security Group for Jenkins EC2 Server

### Compute

- ECS Cluster
- ECS Services
- ECS Task Definitions
- AWS Fargate Containers
- Jenkins EC2 Server

### Load Balancing

- Application Load Balancer
- Target Groups
- Listener Rules

### Scaling

- ECS Auto Scaling Policies

### Monitoring

- CloudWatch Log Groups

### IAM Roles

- ECS Task Execution Role
- Jenkins EC2 IAM Role

Attached Jenkins permissions:

- AmazonECS_FullAccess
- AmazonEC2ContainerRegistryFullAccess

---

## Jenkins Server

Terraform provisions a dedicated Jenkins server.

### Server Specifications

- Name: Jenkins-Server-Tech-1
- Operating System: Ubuntu
- Instance Type: m7i-flex.large
- Storage: 30 GB
- Public IP Enabled

### Jenkins Access

```text
http://EC2_PUBLIC_IP:8080
```

---

## Jenkins CI/CD Workflow

When code is pushed to the `main` branch, Jenkins automatically performs:

1. Pull latest source code from GitHub
2. Build frontend Docker image
3. Build backend Docker image
4. Authenticate to Amazon ECR
5. Push images to ECR
6. Register updated ECS task definitions
7. Trigger ECS deployments
8. Roll out updated containers

GitHub webhook integration was configured to automatically trigger builds after every push to the `main` branch.

---

## Main Jenkins Pipeline File

```text
Jenkinsfile
```

This file defines all Jenkins build and deployment stages.

---

## ECS Resources Used

### Cluster

```text
techchallenge1-cluster
```

### Services

```text
techchallenge1-frontend-svc
techchallenge1-backend-svc
```

---

## Terraform File Structure

| File | Purpose |
|------|---------|
| provider.tf | AWS provider configuration |
| variables.tf | Terraform input variables |
| terraform.tfvars | Environment values |
| network.tf | VPC, subnets, routing |
| security.tf | Security groups |
| iam.tf | IAM roles and permissions |
| alb.tf | Load balancer resources |
| ecs.tf | ECS cluster, services, tasks |
| autoscaling.tf | ECS scaling policies |
| logs.tf | CloudWatch logging |
| ec2.tf | Jenkins server deployment |
| outputs.tf | Terraform outputs |

---

## How to Run This Project

### Terraform Infrastructure

```bash
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Jenkins Deployment Workflow

```bash
git checkout main
git add .
git commit -m "Update application"
git push origin main
```

After pushing to `main`, Jenkins automatically starts the deployment pipeline.

---

## Local Docker Testing

```bash
docker compose up --build
```

---

## Load Testing

Used Siege to simulate traffic and validate scaling behavior.

```bash
siege -c 250 -t 2M http://YOUR-ALB-DNS/
```

Result:

- Frontend service auto scaled successfully
- Application remained available under load

---

## Skills Demonstrated

- Jenkins CI/CD
- Terraform
- Docker
- AWS ECS
- AWS Fargate
- Amazon ECR
- IAM
- Linux Administration
- Load Balancing
- Auto Scaling
- DevOps Automation

---

## Benefits of This Branch

- Dedicated Jenkins automation server
- Full CI/CD pipeline control
- Real world Jenkins on EC2 deployment model
- Automated GitHub webhook builds
- Reproducible infrastructure with Terraform

---

## Author

Phillip Oyediran