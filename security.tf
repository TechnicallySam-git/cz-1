resource "aws_security_group" "alb" {
  name        = "${var.vpc_name}-alb-sg"
  description = "Allow public web traffic to the load balancer"
  vpc_id      = aws_vpc.spoke.id

  tags = {
    Name    = "${var.vpc_name}-alb-sg"
    project = "Case Study 1"
  }

  ingress {
    description = "HTTP from the internet"
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

resource "aws_security_group" "web" {
  name        = "${var.vpc_name}-web-sg"
  description = "Allow web traffic only from the public load balancer"
  vpc_id      = aws_vpc.spoke.id

  tags = {
    Name    = "${var.vpc_name}-web-sg"
    project = "Case Study 1"
  }

  ingress {
    description     = "HTTP from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "${var.vpc_name}-db-sg"
  description = "Allow MariaDB only from the web servers"
  vpc_id      = aws_vpc.spoke.id

  tags = {
    Name    = "${var.vpc_name}-db-sg"
    project = "Case Study 1"
  }

  ingress {
    description     = "MariaDB from the web tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
