locals {
  tags = merge(var.default_tags, var.extra_tags)
}

data "aws_availability_zones" "region_azs" {
  all_availability_zones = false
  state                  = "available"

}

locals {
  azs           = data.aws_availability_zones.region_azs.names
  no_of_subnets = length(var.cidr_blocks)
}

resource "aws_subnet" "subnet" {

  count             = local.no_of_subnets
  vpc_id            = var.vpc_id
  cidr_block        = element(var.cidr_blocks, count.index)
  availability_zone = element(local.azs, count.index)


  private_dns_hostname_type_on_launch = "ip-name"
  tags = merge({
    "Name" = "${var.vpc_name}-${element(local.azs, count.index)}-private-subnet"
    #   "kubernetes.io/role/internal-elb" = "1"
    #   "kubernetes.io/cluster/${var.project_name}-eks-cluster"="shared"
  }, local.tags)

}

resource "aws_route_table" "route_table" {

  count  = local.no_of_subnets
  vpc_id = var.vpc_id
  /*
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = element(var.instance_network_ids, count.index) # it will be instance-id for private subnets and igw for public subnets
  }
  */
  tags = merge({
    "Name" = "${var.vpc_name}-${element(local.azs, count.index)}-private-route-table"
  }, var.default_tags)
}


resource "aws_route" "public_route" {
  count                  = length(var.instance_network_ids)
  route_table_id         = element(aws_route_table.route_table, count.index).id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = element(var.instance_network_ids, count.index)
}

resource "aws_route_table_association" "route_table_association" {
  count          = local.no_of_subnets
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.route_table[count.index].id
}


resource "aws_network_acl" "private_nacl" {

  vpc_id = var.vpc_id
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = merge({
    "Name" = "${var.vpc_name}-private-nacl"
  }, var.default_tags)

}
resource "aws_network_acl_association" "nacl_association" {
  count          = local.no_of_subnets
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.subnet[count.index].id
}
