# Policy document allowing ECS tasks to assume IAM roles
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Execution role used by ECS to run tasks (pull images, send logs)
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

# Attach AWS-managed policy for ECS execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task role used by application inside container (custom permissions later)
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

# Allows EC2 to assume this IAM role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role for Jenkins EC2 server
resource "aws_iam_role" "jenkins_ec2_role" {
  name               = "${var.project_name}-jenkins-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Allows Jenkins to manage ECS deployments
resource "aws_iam_role_policy_attachment" "jenkins_ecs_full_access" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# Allows Jenkins to push/pull images in ECR
resource "aws_iam_role_policy_attachment" "jenkins_ecr_full_access" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# Instance profile attaches the IAM role to EC2
resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "${var.project_name}-jenkins-instance-profile"
  role = aws_iam_role.jenkins_ec2_role.name
}