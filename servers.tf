// TODO: apply IAM role to instance to access secrets and SSM

// Instance AMI
data "aws_ami" "cloud-1" {
  owners = ["self"]

  filter {
    name   = "name"
    values = ["cloud-1"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Instance template
resource "aws_launch_template" "wp" {
  name                   = "wp_template"
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.wp_sg.id]
  update_default_version = true

  image_id = data.aws_ami.cloud-1.id
}

// TODO Scale policy (CPU usage? LB traffic?)

// Attach auto-scaling group to ALB
resource "aws_autoscaling_attachment" "asg_attachment_wp" {
  autoscaling_group_name = aws_autoscaling_group.wp.id
  lb_target_group_arn    = aws_lb_target_group.wp.arn
}

// auto-scaling group definition
resource "aws_autoscaling_group" "wp" {
  // should distribute instance between the two AZ/subnets
  vpc_zone_identifier = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  min_size            = 2
  max_size            = 5 // 💸

  launch_template {
    id      = aws_launch_template.wp.id
    version = "$Latest"
  }

  # // dissociate tf from scaling
  # lifecycle {
  #   ignore_changes = [desired_capacity, target_group_arns]
  # }
}
