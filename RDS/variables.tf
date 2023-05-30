variable "region" {
  description = "AWS region"
}

variable "db_name" {
  type        = string
  description = "RDS database name"
  default = "aime"
  sensitive   = true
}

variable "username" {
  type        = string
  description = "RDS database username"
  sensitive   = true
}

variable "password" {
  type        = string
  description = "RDS database password"
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  default = "db.t2.micro"
}

variable "allocated_storage" {
  description = "RDS allocated storage (in GB)"
  default = "5"
}

variable "publicly_accessible" {
  description = "RDS publicly accessible"
  default     = false
}

variable "rds_sg_id" {
  description = "RDS Secutiry Group"
}

variable "private_subnet_ids-01" {
  description = "RDS Subnet Private"
}

variable "vpc_id" {
  description = "RDS VPC ID"
}
