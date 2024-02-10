resource "aws_launch_template" "default" {
  name                   = "${var.cluster_name}-${var.ng_name}-template"
  update_default_version = true
  iam_instance_profile {
    arn = aws_iam_instance_profile.default.arn
  }
  image_id      = var.ami_id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = var.ebs_volume_size
      volume_type = "gp3"
    }
  }
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [var.node_group_sg_id]
  user_data              = base64encode(templatefile("${path.module}/templates/userdata.sh.tmpl", local.user_data_vars))
  tags                   = merge({ "Name" = "${var.cluster_name}-${var.ng_name}-template" }, var.default_tags)

}