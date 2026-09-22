
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


resource "aws_rds_instance" "db" {
  allocated_storage    = 20
  engine               = "mariadb"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "5Z7peD0D2JzV::R0ibAL0bT~"
  parameter_group_name = "default.mariadb8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "mariadb-1"
  }
}
