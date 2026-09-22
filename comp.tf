
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


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-*-amd64-server-*"]
  }
  owners = ["099720109477"]
}


resource "aws_instance" "web_server-1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
    
  subnet_id = aws_subnet.ec2_subnet.id

  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "web-server-1"

  }
}


resource "aws_instance" "web_server-2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
    
  subnet_id = aws_subnet.db_subnet.id

  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "web-server-2"
  }
}
