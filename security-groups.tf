resource "aws_security_group" "security_group_bastion_host" {
  name        = "${var.project_name}-${var.environment}-sg-bastion"
  description = "Bastion host security group that allows 22 from specific IP"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-${var.environment}-sg-bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_allow_bastion_22" {
  security_group_id = aws_security_group.security_group_bastion_host.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "ingress_allow_bastion_80" {
  security_group_id = aws_security_group.security_group_bastion_host.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "ingress_allow_bastion_443" {
  security_group_id = aws_security_group.security_group_bastion_host.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_bastion_ipv4" {
  security_group_id = aws_security_group.security_group_bastion_host.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "security_group_app_server" {
  name        = "${var.project_name}-${var.environment}-sg-appserver"
  description = "App server security group that allows 80,443 from ALB"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-${var.environment}-sg-appserver"
  }
}

resource "aws_security_group" "security_group_db_server" {
  name        = "${var.project_name}-${var.environment}-sg-dbserver"
  description = "App server security group that allows 3306 from App server"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-${var.environment}-sg-dbserver"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_allow_db_3306_from_bastion" {
  security_group_id = aws_security_group.security_group_db_server.id

  referenced_security_group_id = aws_security_group.security_group_bastion_host.id
  from_port   = 3306
  ip_protocol = "tcp"
  to_port     = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_db_ipv4" {
  security_group_id = aws_security_group.security_group_db_server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
