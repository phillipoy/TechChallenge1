# Configure Terraform and AWS provider
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Set AWS region (N. Virginia = us-east-1)
provider "aws" {
  region = var.aws_region
}

# Get available availability zones dynamically
data "aws_availability_zones" "available" {
  state = "available"
}