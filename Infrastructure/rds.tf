resource "aws_db_subnet_group" "my_rds_subnet_group" {
  name       = "my-rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]
  description = "Subnet group for RDS"

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "RDS-SecurityGroup" }
}

resource "aws_db_instance" "my_rds" {
  identifier           = "my-mysql-db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  db_name             = "mydatabase"
  username            = var.db_username
  password            = var.db_password
  db_subnet_group_name = aws_db_subnet_group.my_rds_subnet_group.name
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  depends_on           = [aws_security_group.rds_sg]
  
  backup_retention_period = 7
  skip_final_snapshot    = true

  tags = {
    Name = "MySQL-RDS"
  }
}