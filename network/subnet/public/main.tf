data "aws_availability_zones" "region_azs" {
  all_availability_zones = false
  state                  = "available"
}

locals {
  sorted_azs = slice(sort(data.aws_availability_zones.region_azs.names), 0, length(var.cidr_blocks))
  tags       = merge(var.default_tags, var.extra_tags)
}

resource "aws_subnet" "default" {
  for_each = toset(local.sorted_azs)

  vpc_id                              = var.vpc_id
  cidr_block                          = element(var.cidr_blocks, index(local.sorted_azs, each.value))
  availability_zone                   = each.value
  map_public_ip_on_launch             = true
  private_dns_hostname_type_on_launch = "ip-name"
  tags = merge({
    "Name" = "${var.vpc_name}-${each.value}-public-subnet"
    #   "kubernetes.io/role/internal-elb" = "1"
    #   "kubernetes.io/cluster/${var.project_name}-eks-cluster"="shared"
  }, local.tags)
}

resource "aws_route_table" "default" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
  tags = merge({
    "Name" = "${var.vpc_name}-public-route-table"
  }, var.default_tags)
}

resource "aws_route_table_association" "default" {
  for_each = toset(local.sorted_azs)

  subnet_id      = aws_subnet.default[each.value].id
  route_table_id = aws_route_table.default.id
}

resource "aws_network_acl" "default" {
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

 resource "aws_network_acl_association" "default" {
   for_each = toset(local.sorted_azs)

   network_acl_id = aws_network_acl.default.id
   subnet_id      = aws_subnet.default[each.value].id
 }
