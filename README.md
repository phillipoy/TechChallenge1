# Tech Challenge 1 GitOps Branch  
## Full DevOps Deployment with GitHub Actions, Terraform, ECS Fargate, and EC2

## Project Overview

This branch demonstrates the same full application deployment as the main branch, but uses GitHub Actions for CI/CD instead of Jenkins.

The application includes a frontend and backend service containerized with Docker and deployed to Amazon ECS using AWS Fargate. Infrastructure is provisioned with Terraform, while deployments are automated through GitHub Actions using a GitOps workflow.

This branch exists to show an alternative modern CI/CD method while reusing the same AWS infrastructure.

---

## Branch Purpose

- `main` branch = Jenkins CI/CD pipeline running on EC2  
- `gitops` branch = GitHub Actions CI/CD pipeline

Both branches deploy the same project, but use different automation tools.

---

## Core Technologies Used

- AWS EC2
- Amazon ECS
- AWS Fargate
- Amazon ECR
- Application Load Balancer
- Terraform
- GitHub Actions
- Docker
- GitHub
- CloudWatch
- IAM
- Ubuntu Linux

---

## Solution Architecture

GitHub Repository  
↓  
GitHub Actions Workflow  
↓  
Build Frontend and Backend Docker Images  
↓  
Push Images to Amazon ECR  
↓  
Update ECS Services  
↓  
Deploy Containers to ECS Fargate  
↓  
Serve Traffic Through Application Load Balancer

---

## Infrastructure Provisioned with Terraform

Terraform is still used to deploy and manage all AWS resources.

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
- GitHub Actions IAM User / Credentials

---

## GitHub Actions CI/CD Workflow

When code is pushed to the `gitops` branch, GitHub Actions automatically performs:

1. Pull latest source code
2. Authenticate to AWS using GitHub Secrets
3. Build frontend Docker image
4. Build backend Docker image
5. Push images to Amazon ECR
6. Trigger ECS frontend deployment
7. Trigger ECS backend deployment
8. Roll out updated containers

---

## Why GitHub Secrets Were Needed

- GitHub Actions runs outside of AWS, so it needs credentials to access ECS and ECR  
- GitHub Secrets securely store AWS credentials without exposing them in code

---

## GitHub Actions Workflow File

```text
.github/workflows/ecs-gitops.yml
```

This file serves the same purpose as a Jenkinsfile, but for GitHub Actions.

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

### GitOps Deployment

```bash
git checkout gitops
git add .
git commit -m "GitOps update"
git push origin gitops
```

After pushing to the `gitops` branch, GitHub Actions automatically runs the deployment workflow.

---

## Local Docker Testing

```bash
docker compose up --build
```

---

## Load Testing

Used Siege to simulate traffic and test scaling.

```bash
siege -c 250 -t 2M http://YOUR-ALB-DNS/
```

Result:

- Frontend service auto scaled successfully
- Application remained available under load

---

## Skills Demonstrated

- GitHub Actions
- Terraform
- Docker
- AWS ECS
- AWS Fargate
- Amazon ECR
- CI/CD Automation
- GitOps Workflows
- IAM Security
- Linux Administration
- Load Balancing
- Auto Scaling

---

## Benefits of This Branch

- Native GitHub automation
- No Jenkins dependency for deployments
- CI/CD directly tied to source control
- Modern GitOps workflow
- Clean separation from Jenkins branch

---

## Author

Phillip Oyediran