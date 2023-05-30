output "vpc-id" {
  value = aws_vpc.aime-vpc.id
}

output "public-subnet-ids-01" {
  value = aws_subnet.aime-public-subnet-01.id
}

output "public-subnet-ids-02" {
  value = aws_subnet.aime-public-subnet-02.id
}

output "private-subnet-ids-01" {
  value = aws_subnet.aime-private-subnet-01.id
}

output "database-subnet-ids-01" {
  value = aws_subnet.aime-database-subnet-01.id
}

output "database-subnet-ids-02" {
  value = aws_subnet.aime-database-subnet-02.id
}

output "rds-sg-id" {
  value = aws_security_group.aime-rds-sg.id
}

output "ec2-sg-id" {
  value = aws_security_group.aime-ec2-sg.id
}

output "alb-sg-id" {
  value = aws_security_group.aime-alb-sg.id
}