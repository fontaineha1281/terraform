terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

}

module "vpc" {
  source = "./VPC"
  state = var.state
}

module "rds" {
  source  = "./RDS"
  db_name = var.db_name
  username = var.username
  password = var.password
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  publicly_accessible = var.publicly_accessible
  vpc_id = module.vpc.vpc_id
  rds_sg_id = module.vpc.rds_sg_id
  private_subnet_ids-01 = module.vpc.private_subnet_ids-01
}



