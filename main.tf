module "vpc" {
  source = "./modules/vpc"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}

resource "tls_private_key" "slipchuk-autoscaling-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "slipchuk_private_key" {
  content  = tls_private_key.slipchuk-autoscaling-ssh-key.private_key_pem
  filename = "${path.module}/slipchuk-autoscaling.pem"
  file_permission = "0600"
}

resource "local_file" "slipchuk_public_key" {
  content  = tls_private_key.slipchuk-autoscaling-ssh-key.public_key_openssh
  filename = "${path.module}/slipchuk-autoscaling.pub"
}


resource "aws_key_pair" "slipchuk-autoscaling-ssh-key" {
  key_name   = "slipchuk-autoscaling-ssh-key"
  public_key = tls_private_key.slipchuk-autoscaling-ssh-key.public_key_openssh
}