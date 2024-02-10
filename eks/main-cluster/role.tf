locals {
  eks_role_policies = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
}

data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = "${var.cluster_name}-role"
  assume_role_policy = data.aws_iam_policy_document.default.json
  tags = merge({
    "Name" = "${var.cluster_name}-role"
  }, var.default_tags)
}


resource "aws_iam_role_policy_attachment" "eks_role_policy_attcement" {
  for_each   = toset(local.eks_role_policies)
  policy_arn = each.value
  role       = aws_iam_role.default.name
}



