# One mount target per AZ, DNS resolution will take care of the rest
resource "aws_efs_mount_target" "wp_private1_target" {
  file_system_id  = aws_efs_file_system.wp.id
  subnet_id       = aws_subnet.subnet1_private.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "wp_private2_target" {
  file_system_id  = aws_efs_file_system.wp.id
  subnet_id       = aws_subnet.subnet2_private.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_file_system" "wp" {
  creation_token = "cloud-1_wp"
}

output "aws_efs_mount_target_dns" {
  value = aws_efs_mount_target.wp_private1_target.dns_name
}
