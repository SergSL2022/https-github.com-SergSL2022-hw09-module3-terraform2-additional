resource "aws_internet_gateway" "slipchuk-igw" {
  vpc_id = aws_vpc.slipchuk.id

  tags = {
    Name = "${var.name}-igw"
  }
}