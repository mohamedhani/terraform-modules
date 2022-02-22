resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = var.enable_dns_hostnames
  enable_dns_hostnames = true
  tags = merge({
    "Name" = "${var.vpc_name}"
  },var.default_tags)
}


resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  tags = merge({
    "Name" = "${var.vpc_name}-default-rt"
  },var.default_tags)
}


/* the default security group allow access to internet   
    and allow ssh access from internal 
*/

resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.main_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    cidr_blocks = [var.cidr_block]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22

  }
  tags = merge({
    "Name" = "${var.vpc_name}-default-sg"
  },var.default_tags)
}



resource "aws_default_network_acl" "default_network_acl" {
  default_network_acl_id = aws_vpc.main_vpc.default_network_acl_id
  ingress {
    protocol   = -1
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    cidr_block = var.cidr_block
  }

  egress {
    protocol   = -1
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  tags =  merge({
    "Name" = "${var.vpc_name}-default-nacl"
  },var.default_tags)

}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge({
    "Name" = "${var.vpc_name}-igw"
  },var.default_tags)
}
