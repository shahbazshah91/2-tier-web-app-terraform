resource "aws_eip" "eip1" {
  domain   = "vpc"

  tags = {
        Name = "${var.project_name}-${var.environment}-eip1"
    }
}

resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "${var.project_name}-${var.environment}-NAT-az1"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private_route_table_az1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-pvt-route-table-az1"
  }
}

resource "aws_route_table_association" "private_data_subnet_az1_association" {
  subnet_id      = aws_subnet.private_data_subnet_az1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}
