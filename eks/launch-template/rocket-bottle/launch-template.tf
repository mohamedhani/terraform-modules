
resource "aws_launch_template" "node_group_template" {
  name                   = "${var.cluster_name}-${var.ng_name}-template"
  update_default_version = true
  iam_instance_profile {
    arn = aws_iam_instance_profile.node_group_instace_profile.arn
  }
  image_id      = var.ami_id
  instance_type = var.instance_type
  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  vpc_security_group_ids = [var.node_group_sg_id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tmpl", local.user_data_vars))
  tags      = merge({ "Name" = "${var.cluster_name}-${var.ng_name}-template" }, var.default_tags)
}
