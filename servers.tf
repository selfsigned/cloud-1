// Could be adapted to scale to N servers

// First server

resource "aws_lb_target_group_attachment" "wp1" {
  target_group_arn = aws_lb_target_group.wp.arn
  target_id        = aws_instance.wp1.id
  port             = 80
}

resource "aws_instance" "wp1" {
  instance_type = var.instance-type
  // TODO provision custom image with packer/ansible
  ami                    = "ami-05bfef86a955a699e"
  subnet_id              = aws_subnet.subnet1.id
  private_ip             = var.wp1_ip
  vpc_security_group_ids = [aws_security_group.wp_sg.id]
}

// Second server

# resource "aws_lb_target_group_attachment" "wp2" {
#   target_group_arn = aws_lb_target_group.wp.arn
#   target_id        = aws_instance.wp2.id
#   port             = 80
# }
