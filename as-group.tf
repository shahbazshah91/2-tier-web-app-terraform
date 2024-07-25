#creating launch template to use with autoscaling group
resource "aws_launch_template" "launch_template" {
  name = "${var.project_name}-${var.environment}-launch-template"

  image_id = "ami-0a0e5d9c7acc336f1"

  instance_type = "t2.micro"

  key_name = "newkey3"

  vpc_security_group_ids = [aws_security_group.security_group_app_server.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-launch-template"
    }
  }

  user_data = filebase64("ec2-user-data.sh")
}

#creating autoscaling group
resource "aws_autoscaling_group" "as_group" {
  
  name                = "${var.project_name}-${var.environment}-as-group"
  
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.public_subnet_az1.id]

  #attaching app loadbalancer to autoscaling group
  target_group_arns = [aws_lb_target_group.target_group.arn]
  
  health_check_grace_period = "600"
  health_check_type         = "ELB"

  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2

  #setting "Launch before terminating" policy
  instance_maintenance_policy {
    min_healthy_percentage = 100
    max_healthy_percentage = 110
  }

  tag {
    key                 = "group"
    value               = "autoscaling"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "as_group_scaling_policy" {
  autoscaling_group_name = aws_autoscaling_group.as_group.name
  name                   = "as-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
