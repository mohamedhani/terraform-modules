
locals {
  policies = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}
resource "aws_iam_role" "default" {
  name = "${var.cluster_name}-${var.name}"

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

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  for_each   = toset(local.policies)
  policy_arn = each.value
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.default.name
}
