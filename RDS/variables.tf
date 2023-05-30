variable "region" {
  type = string
  description = "AWS region"
}

variable "vpc-id" {
  type = any
  description = "RDS VPC ID"
}

variable "state" {
  type = string
  description = "Environment of project"
}

variable "rds-sg-id" {
  type = any
  description = "ID of RDS security group"
}

variable "database-subnet-ids-01" {
  type = any
  description = "ID of database subnet 01"
}

variable "database-subnet-ids-02" {
  type = any
  description = "ID of database subnet 02"
}

variable "db-name" {
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

variable "instance-class" {
  description = "RDS instance class"
  default = "db.t2.micro"
}

variable "allocated-storage" {
  description = "RDS allocated storage (in GB)"
  default = "5"
}

variable "publicly-accessible" {
  description = "RDS publicly accessible"
  default     = false
}


