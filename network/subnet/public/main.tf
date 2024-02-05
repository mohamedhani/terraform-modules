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

  count      = local.no_of_subnets
  vpc_id     = var.vpc_id
  cidr_block = element(var.cidr_blocks, count.index)

  availability_zone                   = element(local.azs, count.index)
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
  tags = merge({
    "Name" = "${var.vpc_name}-${element(local.azs, count.index)}-public-subnet"
    #   "kubernetes.io/role/internal-elb" = "1"
    #   "kubernetes.io/cluster/${var.project_name}-eks-cluster"="shared"
  }, local.tags)


}



resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = merge({
    "Name" = "${var.vpc_name}-public-route-table"
  }, var.default_tags)
}

resource "aws_route_table_association" "route_table_association" {
  count          = local.no_of_subnets
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_network_acl" "public_acl" {

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
    "Name" = "${var.vpc_name}-public-nacl"
  }, var.default_tags)
}

resource "aws_network_acl_association" "nacl_association" {
  count          = local.no_of_subnets
  network_acl_id = aws_network_acl.public_acl.id
  subnet_id      = aws_subnet.subnet[count.index].id
}

