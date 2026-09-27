data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "spoke" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "vpc-${var.vpc_name}"
    project = "Case Study 1"
    type    = "spoke"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.spoke.id
  cidr_block              = "10.0.11.0/28"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-subnet-${var.vpc_name}-1"
    project = "Case Study 1"
    tier    = "public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.spoke.id
  cidr_block              = "10.0.12.0/28"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-subnet-${var.vpc_name}-2"
    project = "Case Study 1"
    tier    = "public"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = "10.0.1.0/28"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "private-subnet-${var.vpc_name}-1"
    project = "Case Study 1"
    tier    = "private"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = "10.0.2.0/28"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name    = "private-subnet-${var.vpc_name}-2"
    project = "Case Study 1"
    tier    = "private"
  }
}

resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = "10.0.20.0/28"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "db-subnet-${var.vpc_name}-1"
    project = "Case Study 1"
    tier    = "database"
  }
}

resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = "10.0.21.0/28"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name    = "db-subnet-${var.vpc_name}-2"
    project = "Case Study 1"
    tier    = "database"
  }
}

resource "aws_internet_gateway" "spoke" {
  vpc_id = aws_vpc.spoke.id

  tags = {
    Name    = "igw-${var.vpc_name}"
    project = "Case Study 1"
  }
}
