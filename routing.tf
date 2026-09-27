resource "aws_vpc_peering_connection" "spoke_to_hub" {
  vpc_id      = aws_vpc.spoke.id
  peer_vpc_id = var.hub_vpc_id
  auto_accept = var.auto_accept_peering

  tags = {
    Name    = "${var.vpc_name}-to-vpc-hub-1-peering"
    project = "Case Study 1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.spoke.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spoke.id
  }

  tags = {
    Name    = "public-rt-${var.vpc_name}"
    project = "Case Study 1"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.spoke.id

  route {
    cidr_block                = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.spoke_to_hub.id
  }

  tags = {
    Name    = "private-rt-${var.vpc_name}"
    project = "Case Study 1"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.spoke.id

  route {
    cidr_block                = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.spoke_to_hub.id
  }

  tags = {
    Name    = "db-rt-${var.vpc_name}"
    project = "Case Study 1"
  }
}

resource "aws_route_table_association" "database_1" {
  subnet_id      = aws_subnet.db_1.id
  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database_2" {
  subnet_id      = aws_subnet.db_2.id
  route_table_id = aws_route_table.database.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.spoke.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = [
    aws_route_table.private.id
  ]

  tags = {
    Name    = "${var.vpc_name}-s3-endpoint"
    project = "Case Study 1"
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

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.spoke.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name    = "${var.vpc_name}-ssm-endpoint"
    project = "Case Study 1"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.spoke.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name    = "${var.vpc_name}-ssmmessages-endpoint"
    project = "Case Study 1"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.spoke.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name    = "${var.vpc_name}-ec2messages-endpoint"
    project = "Case Study 1"
  }
}