provider "aws" {
  alias  = "useast"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eucentral"
  region = "eu-central-1"
}

# Default VPCs
data "aws_vpc" "default_useast" {
  provider = aws.useast
  default  = true
}

data "aws_vpc" "default_eucentral" {
  provider = aws.eucentral
  default  = true
}

# Security group for us-east-1
resource "aws_security_group" "east_sg1" {
  provider    = aws.useast
  name        = "east-nginx-sg1"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default_useast.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for eu-central-1
resource "aws_security_group" "central_sg1" {
  provider    = aws.eucentral
  name        = "central-nginx-sg1"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default_eucentral.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 in us-east-1 with Nginx
resource "aws_instance" "east_instance" {
  provider      = aws.useast
  ami           = "ami-0521cb2d60cfbb1a6"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.east_sg1.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "EastInstance"
  }
}

# EC2 in eu-central-1 with Nginx
resource "aws_instance" "central_instance" {
  provider      = aws.eucentral
  ami           = "ami-09f224bab7225d943"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.central_sg1.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable nginx1
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "CentralInstance"
  }
}

