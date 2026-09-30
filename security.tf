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
}

resource "aws_vpc_security_group_egress_rule" "alb_to_web" {
  security_group_id            = aws_security_group.alb.id
  description                  = "HTTP to the web tier"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.web.id
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
  ingress {
    description = "Node exporter scrape from the hub monitoring instance"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.hub_route_priv_table_cidr]
  }
}

resource "aws_vpc_security_group_egress_rule" "web_to_db" {
  security_group_id            = aws_security_group.web.id
  description                  = "MariaDB to the database"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.db.id
}

resource "aws_vpc_security_group_egress_rule" "web_to_endpoints" {
  security_group_id            = aws_security_group.web.id
  description                  = "HTTPS to the SSM endpoints"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.vpc_endpoints.id
}

resource "aws_vpc_security_group_egress_rule" "web_to_s3" {
  security_group_id = aws_security_group.web.id
  description       = "HTTPS to S3 via the gateway endpoint"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_id    = aws_vpc_endpoint.s3.prefix_list_id
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
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.vpc_name}-vpce-sg"
  description = "Allow HTTPS from web tier to SSM interface endpoints"
  vpc_id      = aws_vpc.spoke.id

  ingress {
    description     = "HTTPS from web tier"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.vpc_name}-vpce-sg"
    project = "Case Study 1"
  }
}