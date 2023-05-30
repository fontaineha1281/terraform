resource "aws_db_subnet_group" "aime-db-subnet-group" {
  name       = "aime-${var.state}-db-subnet-group"
  subnet_ids = [var.database-subnet-ids-01, var.database-subnet-ids-02]

  tags = {
    Name = "aime-${var.state}-db-subnet-group"
  }
}
resource "aws_db_instance" "aime-rds-instance" {
  db_name                = "aime-${var.state}-rds-instance"
  allocated_storage      = var.allocated-storage
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.instance-class
  identifier_prefix      = var.db-name
  username               = var.username
  password               = var.password
  publicly_accessible    = var.publicly-accessible
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.rds-sg-id]
  db_subnet_group_name   = aws_db_subnet_group.aime-db-subnet-group.name
  tags = {
    Name = "aime-${var.state}-rds-instance"
  }
}


