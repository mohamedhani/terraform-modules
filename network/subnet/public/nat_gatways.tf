module "nat_gateway" {
  for_each = toset(var.single_nat_gateway ? [local.sorted_azs[0]] : local.sorted_azs)

  source      = "../../nat_gatway"
  name_prefix = "${var.vpc_name}-${each.value}"
  subnet_id   = aws_subnet.default[each.value].id
}
