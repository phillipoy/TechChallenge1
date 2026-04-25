# AWS region
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Project name used for tagging and naming resources
variable "project_name" {
  type    = string
  default = "techchallenge1"
}

# CIDR block for VPC
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# Public subnets (for ALB + NAT)
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Private subnets (for ECS tasks)
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

# IP range allowed for SSH and Jenkins access
variable "my_ip_cidr" {
  type        = string
  description = "CIDR block allowed to access Jenkins server"
}

# ECR image for frontend
variable "frontend_ecr_image" {
  type = string
}

# ECR image for backend
variable "backend_ecr_image" {
  type = string
}

# Ports exposed by containers
variable "frontend_container_port" {
  type    = number
  default = 3000
}

variable "backend_container_port" {
  type    = number
  default = 8080
}