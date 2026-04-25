# ECR repo for frontend
resource "aws_ecr_repository" "frontend" {
  name = "frontend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-frontend-ecr"
  }
}

# ECR repo for backend
resource "aws_ecr_repository" "backend" {
  name = "backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-backend-ecr"
  }
}