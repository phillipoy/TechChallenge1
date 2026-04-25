# Security group for Jenkins server
# Allows SSH and Jenkins UI access from your IP only
resource "aws_security_group" "jenkins_ec2" {
  name        = "${var.project_name}-jenkins-ec2-sg"
  description = "Allow SSH and Jenkins access"
  vpc_id      = aws_vpc.main.id

  # SSH access
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Jenkins web UI
  ingress {
    description = "Jenkins UI access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-jenkins-ec2-sg"
  }
}

# Jenkins EC2 instance
resource "aws_instance" "jenkins" {
  ami                         = "ami-0ec10929233384c7f"
  instance_type               = "m7i-flex.large"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.jenkins_ec2.id]
  key_name                    = "NVirginiaRegionKP"
  # Attach IAM role to EC2 server
  iam_instance_profile        = aws_iam_instance_profile.jenkins_instance_profile.name
  associate_public_ip_address = true

  # Root storage volume
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "Jenkins-Server-Tech-1"
  }
}