resource "aws_vpc" "slipchuk" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name}-vpc"
  }
}

# ======================================== SUBNETS ====================================
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id     = aws_vpc.slipchuk.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.slipchuk.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = "eu-north-1c"

  tags = {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

# ==================================== PUBLIC ROUTE TABLE ===============================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.slipchuk.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.slipchuk-igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ==================================== PRIVATE ROUTE TABLE ===============================
resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.slipchuk.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.slipchuk-nat[0].id
  }

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}