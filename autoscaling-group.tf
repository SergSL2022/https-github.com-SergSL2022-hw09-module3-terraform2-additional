data "aws_ami" "ubuntu_24_04_latest" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# ====================================== Launch Template ====================================
resource "aws_launch_template" "slipchuk-template" {
  name_prefix   = "slipchuk-"
  image_id      = data.aws_ami.ubuntu_24_04_latest.id 
  instance_type = "t3.micro"
  key_name      = aws_key_pair.slipchuk-autoscaling-ssh-key.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.slipchuk-private.id]
    subnet_id                   = module.vpc.private_subnet_ids[0]
  }

  tag_specifications {
    resource_type = "instance"
    tags = [{
      Name = "slipchuk-autoscaling"
    }]
  }
}


# ====================================== Autoscaling Group ====================================
resource "aws_autoscaling_group" "slipchuk" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  launch_template {
    id      = aws_launch_template.slipchuk-template.id
    version = "$Latest"
  }

  vpc_zone_identifier = module.vpc.private_subnet_ids
  
}