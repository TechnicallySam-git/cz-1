data "aws_rds_engine_version" "mariadb" {
  engine  = "mariadb"
  version = var.db_engine_version
}

resource "aws_db_parameter_group" "mariadb" {
  name   = "${var.vpc_name}-mariadb"
  family = data.aws_rds_engine_version.mariadb.parameter_group_family

  tags = {
    Name    = "${var.vpc_name}-mariadb"
    project = "Case Study 1"
  }
}

resource "aws_db_subnet_group" "mariadb" {
  name       = "${var.vpc_name}-db-subnet-group"
  subnet_ids = [aws_subnet.db_1.id, aws_subnet.db_2.id]

  tags = {
    Name    = "${var.vpc_name}-db-subnet-group"
    project = "Case Study 1"
  }
}

resource "aws_db_instance" "mariadb" {
  identifier                  = "${var.vpc_name}-mariadb"
  allocated_storage           = 20
  max_allocated_storage       = 50
  storage_type                = "gp3"
  storage_encrypted           = true
  engine                      = data.aws_rds_engine_version.mariadb.engine
  engine_version              = data.aws_rds_engine_version.mariadb.version
  instance_class              = "db.t4g.micro"
  availability_zone           = data.aws_availability_zones.available.names[0]
  multi_az                    = false
  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true
  parameter_group_name        = aws_db_parameter_group.mariadb.name
  db_subnet_group_name        = aws_db_subnet_group.mariadb.name
  vpc_security_group_ids      = [aws_security_group.db.id]
  publicly_accessible         = false
  backup_retention_period     = 7
  skip_final_snapshot         = var.skip_final_snapshot

  tags = {
    Name    = "${var.vpc_name}-mariadb"
    project = "Case Study 1"
  }
}
