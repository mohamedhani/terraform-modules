locals {
  tags = merge(var.default_tags, var.extra_tags)
}

resource "aws_eip" "default" {
  domain = "vpc"
  tags = merge({
    Name = "${var.name_prefix}-eip"
  }, local.tags)
}

resource "aws_nat_gateway" "default" {
  allocation_id     = aws_eip.default.id
  connectivity_type = "public"
  subnet_id         = var.subnet_id

  tags = merge({
    Name = "${var.name_prefix}-nat-gateway"
  }, local.tags)
}
