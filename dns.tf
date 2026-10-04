resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  tags = {
    Name    = "${var.vpc_name}-https-listener"
    project = "Case Study 1"
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

