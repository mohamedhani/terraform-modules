locals {
  role_policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}
data "aws_iam_policy_document" "node_group_assumerole_policy" {
  statement {

    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node_group_role" {
  name = "${var.cluster_name}-${var.ng_name}-node-group-role"

  assume_role_policy = data.aws_iam_policy_document.node_group_assumerole_policy.json
  tags               = merge({ "Name" = "${var.cluster_name}-${var.ng_name}-node-group-role" }, var.default_tags)
}

resource "aws_iam_role_policy_attachment" "node_group_role_policy_attachment" {
  for_each   = toset(local.role_policies)
  policy_arn = each.value
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_instance_profile" "node_group_instace_profile" {
  name = "${var.cluster_name}-${var.ng_name}-node-group-role"
  role = aws_iam_role.node_group_role.name
}