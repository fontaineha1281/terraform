
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

  tags = {
    Name = "RDS-aime"
  }
}


