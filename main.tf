terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "aime-terraform-state"
    key    = "staging/terraform.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
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
}



