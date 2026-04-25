# Tech Challenge 1  
## Full DevOps Deployment with Jenkins, Terraform, ECS Fargate, and EC2

## Project Overview

This project demonstrates a complete end to end DevOps deployment using AWS cloud services, Infrastructure as Code, containerization, and CI/CD automation.

The application consists of a frontend and backend service containerized with Docker and deployed to Amazon ECS using AWS Fargate. Infrastructure was provisioned with Terraform, while Jenkins was hosted on a dedicated EC2 server to automate build and deployment pipelines.

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

Terraform was used to deploy and manage all cloud infrastructure.

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

A dedicated Jenkins server was deployed using Terraform.

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

## CI/CD Pipeline Workflow

Jenkins automates the full deployment lifecycle.

### Pipeline Stages

1. Pull latest source code from GitHub
2. Build frontend Docker image
3. Build backend Docker image
4. Authenticate to Amazon ECR
5. Push images to ECR
6. Register updated ECS task definition
7. Trigger ECS service deployment
8. Roll out new containers

---

## Docker Usage

### Local Development

```bash
docker compose up --build
```

### Containers Built

- Frontend
- Backend

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

## Deployment Commands

### Terraform Deployment

```bash
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Jenkins Deployment

1. Access Jenkins in browser
2. Configure GitHub credentials
3. Configure pipeline job
4. Connect Jenkinsfile from repository
5. Run build pipeline

---

## Load Testing

Used Siege to simulate production traffic and validate scaling behavior.

```bash
siege -c 250 -t 2M http://YOUR-ALB-DNS/
```

Result:

- Frontend service auto scaled successfully
- Application remained available under load

---

## Skills Demonstrated

- AWS Cloud Infrastructure
- Terraform
- Jenkins CI/CD
- Docker
- ECS Fargate
- ECR
- IAM
- Linux Administration
- Networking
- Auto Scaling
- Load Balancing
- DevOps Automation

---

## Future Enhancements

- HTTPS with ACM certificate
- Route53 custom domain
- GitHub Actions GitOps branch
- Blue Green deployments
- CloudWatch alarms
- Private Jenkins subnet
- AWS WAF integration

---

## Author

Phillip Oyediran