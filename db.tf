// RDS private subnet
resource "aws_db_subnet_group" "wpdb" {
  name       = "wpdb_subnet"
  subnet_ids = [aws_subnet.subnet1_private.id, aws_subnet.subnet2_private.id]
}

// RDS instance
resource "aws_db_instance" "wpdb" {
  db_name             = "wpdb"
  engine              = "mariadb"
  engine_version      = "10.6"
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true

  allocated_storage     = 5
  max_allocated_storage = 10

  port = 3306
  username = var.db-user
  password = var.db-password

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.wpdb.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  // Debug
  apply_immediately = true
}

output "rds_endpoint" {
  value = "${aws_db_instance.wpdb.endpoint}"
}
