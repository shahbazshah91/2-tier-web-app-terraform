# data "aws_kms_alias" "rds_default" {
#   name = "alias/mytestkey"
# }

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "main"
  subnet_ids = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id ]

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  db_name              = "mydb"
  engine               = "mariadb"
  engine_version       = "10.11.4"
  instance_class       = "db.t3.micro"
  identifier           = "dev-rds-db"
  username             = "admin"  #required
  manage_master_user_password   = true
  # master_user_secret_kms_key_id = data.aws_kms_alias.rds_default.id   If not specified, the default KMS key for your Amazon Web Services account is used.
  multi_az             = false

  publicly_accessible = false

  allocated_storage    = 20
  storage_type         = "gp2"

  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  vpc_security_group_ids = [aws_security_group.security_group_db_server.id]
  parameter_group_name = "default.mariadb10.11"
  skip_final_snapshot  = true

  tags = {
    Name = "${var.project_name}-${var.environment}-my-database"
  }
}
