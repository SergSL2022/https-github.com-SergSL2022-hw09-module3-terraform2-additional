resource "aws_security_group" "slipchuk-public" {
  name        = "${module.vpc.vpc_name}-public-sg"
  description = "Allow all inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.open_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.vpc.vpc_name}-public-sg"
  }
}

resource "aws_security_group" "slipchuk-private" {
  name        = "${module.vpc.vpc_name}-private-sg"
  description = "Allow outbound traffic only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.vpc.vpc_name}-private-sg"
  }
}