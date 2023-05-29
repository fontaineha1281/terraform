provider "aws" {
  region = var.region
}

module "rds" {
  source  = "./RDS"
  db_name = var.db_name
  username = var.username
  password = var.password
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  publicly_accessible = var.publicly_accessible
}



