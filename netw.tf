terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
}

provider "aws" {
  region = "us-europe-central-1"
}

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "ec2_subnet" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "ec2-subnet"
  }
}
resource "aws_subnet" "db_subnet" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "db-subnet"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.prod.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_alb" "ALB-1" {
  name            = "ALB-1"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.web_sg.id]
  subnets         = [aws_subnet.ec2_subnet.id, aws_subnet.db_subnet.id]

  tags = {
    Name = "ALB-1"
  }
  
}