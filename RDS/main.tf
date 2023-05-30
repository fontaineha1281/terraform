resource "aws_db_subnet_group" "aime-db-subnet" {
  name       = "aime-db-subnet"
  subnet_ids = [var.private_subnet_ids-01]

  tags = {
    Name = "Aime DB Group"
  }
}
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = var.allocated_storage
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.instance_class
  identifier_prefix    = var.db_name
  username             = var.username
  password             = var.password
  publicly_accessible  = var.publicly_accessible
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name = aws_db_subnet_group.aime-db-subnet.name
  tags = {
    Name = "RDS-aime"
  }
}


