resource "aws_eip" "slipchuk-nat" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0
}

resource "aws_nat_gateway" "slipchuk-nat" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0

  allocation_id = aws_eip.slipchuk-nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.name}-nat-gateway"
  }
}