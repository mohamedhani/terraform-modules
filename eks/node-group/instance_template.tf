
resource "aws_key_pair" "node_group_key" {
  key_name   = "${var.cluster_name}-${var.ng_name}-keypair"
  public_key = var.public_key
  tags       = merge({ "Name" = "${var.cluster_name}-${var.ng_name}-keypair" }, var.default_tags)

}

resource "aws_launch_template" "node_group_template" {
  name                   = "${var.cluster_name}-${var.ng_name}-template"
  update_default_version = true
  iam_instance_profile {
    arn = aws_iam_instance_profile.node_group_instace_profile.arn
  }
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.node_group_key.key_name
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [var.node_group_sg_id]
  user_data              = base64encode(templatefile("${path.module}/userdata.sh.tmpl", local.user_data_vars))
  tags                   = merge({ "Name" = "${var.cluster_name}-${var.ng_name}-template" }, var.default_tags)

}