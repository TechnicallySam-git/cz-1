resource "aws_launch_template" "web" {
  name_prefix   = "${var.vpc_name}-web-"
  image_id      = var.web_ami_id
  instance_type = var.web_instance_type

  vpc_security_group_ids = [aws_security_group.web.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.vpc_name}-web"
      project = "Case Study 1"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.vpc_name}-web-asg"
  min_size            = 2
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-web"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }
}
