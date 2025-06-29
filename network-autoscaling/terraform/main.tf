provider "aws" {
  region = var.aws_region
}

# Launch template for application instances
resource "aws_launch_template" "app" {
  name_prefix   = "network-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
    #!/bin/bash
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
}

# Auto Scaling Group for horizontal scaling
resource "aws_autoscaling_group" "app_asg" {
  name                      = "network-app-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.min_size
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  tag {
    key                 = "Name"
    value               = "network-app"
    propagate_at_launch = true
  }
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "network-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
}

# Target group for the ALB
resource "aws_lb_target_group" "app_tg" {
  name     = "network-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Listener for HTTP traffic
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}