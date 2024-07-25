resource "aws_lb_target_group" "target_group" {
  name     = "${var.project_name}-${var.environment}-targetgroup"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  protocol_version = "HTTP1"
  vpc_id   = aws_vpc.vpc.id

  deregistration_delay = "300"

  stickiness {
    enabled = false
    type = "app_cookie"
  }

  health_check {
    enabled = true
    protocol = "HTTP"
    path = "/"
    port = "traffic-port"
    healthy_threshold = "5"
    unhealthy_threshold = "2"
    timeout = "5"
    interval = "30"
    matcher = "200,301,302"
  }
}

resource "aws_lb" "app_lb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.security_group_alb.id]
  subnets            = [aws_subnet.public_subnet_az1.id, aws_subnet.private_data_subnet_az2.id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "port_80_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
