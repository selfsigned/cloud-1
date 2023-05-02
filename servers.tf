// Could be adapted to scale to N servers

# resource "aws_instance" "wp1" {
#   instance_type   = var.instance-type
#   ami             = "05bfef86a955a699e"
#   security_groups = [aws_security_group.wp_sg]

#   // TODO provision custom image with packer/ansible
# }
