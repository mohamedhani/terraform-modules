data "aws_availability_zones" "region_azs" {
  all_availability_zones = false
  state                  = "available"

}

data "aws_ami" "nat_gateway_ami" {
  owners      = ["aws-marketplace", "amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-2018.03.0.20220119.1-x86_64-ebs"]
  }
}
data "aws_vpc" "main_vpc" {
  id = var.vpc_id

}


locals {
  azs           = data.aws_availability_zones.region_azs.names
  no_of_subnets = length(var.subnet_ids)

}


resource "aws_key_pair" "nat_instance_key_pair" {
  key_name   = "bastian-host-key"
  public_key = var.key_pair_public_key

}

resource "aws_instance" "nat_instance" {

  count = local.no_of_subnets

  ami = data.aws_ami.nat_gateway_ami.id

  instance_type          = "t2.micro"
  key_name               = aws_key_pair.nat_instance_key_pair.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.nat_instance_sg.id]
  subnet_id              = element(var.subnet_ids, count.index)
  source_dest_check      = false
  tags = merge({
    "Name" = "${var.vpc_name}-${element(local.azs, count.index)}-nat-instance"
  }, var.default_tags)
}

resource "aws_eip" "nat_instance_eip" {
  count    = local.no_of_subnets
  vpc      = true
  instance = aws_instance.nat_instance[count.index].id

}
resource "aws_security_group" "nat_instance_sg" {
  name   = "nat-instance-sg"
  vpc_id = var.vpc_id

  ingress {
    # allow ssh access
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.main_vpc.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge({
    "Name" = "${var.vpc_name}-nat-instance-sg"
  }, var.default_tags)
}

/*
  root_block_device {
    delete_on_termination =  true
    encrypted = false
    volume_size = 8
    volume_type = "gp2"
    tags = {
      "Name" = "${var.project_name}-${element(local.azs,count.index)}-nat-gw-ebs"
    }
  }
  */
