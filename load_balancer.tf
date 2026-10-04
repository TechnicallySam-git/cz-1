resource "aws_lb" "web" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name    = "${var.vpc_name}-alb"
    project = "Case Study 1"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.vpc_name}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.spoke.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
  }

  tags = {
    Name    = "${var.vpc_name}-web-tg"
    project = "Case Study 1"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  tags = {
    Name    = "${var.vpc_name}-http-listener"
    project = "Case Study 1"
  }

  default_action {
    type          = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    target_group_arn = aws_lb_target_group.web.arn
  }
}
