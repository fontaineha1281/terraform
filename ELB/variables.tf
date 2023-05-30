variable "vpc-id" {
  type = any
  description = "ID of VPC"
}

variable "public-subnet-id-01" {
  type = any
  description = "ID of public subnet 01"
}

variable "public-subnet-id-02" {
  type = any
  description = "ID of public subnet 02"
}

variable "alb-sg-id" {
  type = any
  description = "ID of ALB security group"
}

variable "ec2-backend-id" {
  type = any
  description = "ID of ec2"
}
