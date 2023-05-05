// EC2 Auto-scaling group

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

// TODO remove once ssm works

resource "aws_key_pair" "code" {
  key_name   = "code-key"
  public_key = var.pubkey
}

// Instance template
resource "aws_launch_template" "wp" {
  name                   = "wp_template"
  instance_type          = var.instance-type
  update_default_version = true
  # vpc_security_group_ids = [aws_security_group.wp_sg.id]


  iam_instance_profile {
    name = aws_iam_instance_profile.cloud1profile.name
  }

  key_name = aws_key_pair.code.key_name
  network_interfaces { // TODO remove once SSM works
    associate_public_ip_address = true
    security_groups             = [aws_security_group.wp_sg.id]
  }

  user_data = base64encode(<<EOFF
#!/bin/bash
cat << 'EOF' > /srv/cloud-1/.env
db_host="${split(":", aws_db_instance.wpdb.endpoint)[0]}"
db_user="${var.db-user}"
db_password="${var.db-password}"
db_name="${var.db-name}"

efs_host="${aws_efs_mount_target.wp_private1_target.dns_name}"

url="http://${var.domain}"
title="${var.domain}"
admin_name="${var.wp-user}"
admin_password="${var.wp-password}"
admin_email="${var.wp-email}"
EOF
  EOFF
  )

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
  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}
