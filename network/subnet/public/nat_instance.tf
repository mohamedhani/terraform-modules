module "nat_instances" {
  source              = "../../nat_instance"
  subnet_ids          = aws_subnet.subnet.*.id
  vpc_id              = var.vpc_id
  key_pair_public_key = var.instance_public_key
  vpc_name            = var.vpc_name
}