resource "aws_lb" "aime-alb" {
  name               = "aime-application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb-sg-id]
  subnets            = [var.public-subnet-id-01, var.public-subnet-id-02]

  enable_deletion_protection = true

  tags = {
    Name = "aime-alb"
  }
}

resource "aws_lb_target_group" "aime-target-group" {
  name        = "aime-tg-ec2"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc-id

  tags = {
    Name = "aime-tg"
  }
}

resource "aws_lb_target_group_attachment" "aime-target-group-attachment" {
  target_group_arn = aws_lb_target_group.aime-target-group.arn
  target_id        = var.ec2-backend-id
  port             = 80
}
