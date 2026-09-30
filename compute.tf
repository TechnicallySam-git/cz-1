resource "aws_launch_template" "web" {
  name_prefix   = "${var.vpc_name}-web-"
  image_id      = var.web_ami_id
  instance_type = var.web_instance_type

  iam_instance_profile {
    name = "ec2-get-bucket"
  }

  vpc_security_group_ids = [aws_security_group.web.id]
<<<<<<< HEAD

  user_data = base64encode(<<-EOF
    #!/bin/bash
    umask 077

=======
  user_data = base64encode(<<-EOF
    #!/bin/bash
    umask 077
>>>>>>> 7c45929e03076bd37d39c164ee8ba677a95e2945
    cat > /etc/app.env <<ENV
    DB_HOST=${aws_db_instance.mariadb.address}
    DB_PORT=3306
    DB_NAME=${var.db_name}
    DB_USER=${var.db_username}
    DB_PASSWORD=${var.db_password}
    FLASK_SECRET_KEY=admin
    APP_PASSWORD=changeme
    ENV
<<<<<<< HEAD

=======
>>>>>>> 7c45929e03076bd37d39c164ee8ba677a95e2945
    systemctl restart app.service
    EOF
  )

  tags = {
    Name    = "${var.vpc_name}-web-launch-template"
    project = "Case Study 1"
  }

  tag_specifications {
    resource_type = "instance"
<<<<<<< HEAD

=======
>>>>>>> 7c45929e03076bd37d39c164ee8ba677a95e2945
    tags = {
      Name    = "${var.vpc_name}-web"
      project = "Case Study 1"
      Role    = "web-server"
    }
  }
}

<<<<<<< HEAD

=======
>>>>>>> 7c45929e03076bd37d39c164ee8ba677a95e2945
resource "aws_autoscaling_group" "web" {
  name                = "${var.vpc_name}-web-asg"
  min_size            = 1
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
<<<<<<< HEAD
  target_group_arns    = [aws_lb_target_group.web.arn]
=======
  target_group_arns   = [aws_lb_target_group.web.arn]
>>>>>>> 7c45929e03076bd37d39c164ee8ba677a95e2945
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

  tag {
    key                 = "project"
    value               = "Case Study 1"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }
}
<<<<<<< HEAD


resource "aws_autoscaling_policy" "web_cpu" {
  name                   = "${var.vpc_name}-web-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
  }
}
=======
>>>>>>> 7c45929e03076bd37d39c164ee8ba677a95e2945
