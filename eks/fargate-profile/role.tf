
locals {
  policies = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}
resource "aws_iam_role" "default" {
  name = "${var.name}-${var.cluster_name}-fargate-role"

  assume_role_policy = data.aws_iam_policy_document.fargate_assume_role_document.json
}

data "aws_iam_policy_document" "fargate_assume_role_document" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each   = toset(local.policies)
  policy_arn = each.value
  role       = aws_iam_role.default.name
}
