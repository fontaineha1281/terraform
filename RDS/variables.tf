variable "region" {
  description = "AWS region"
  default = "us-east-1"
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
