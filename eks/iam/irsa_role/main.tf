data "aws_eks_cluster" "main_cluster" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "default" {
  url = data.aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.default.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.default.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = "${var.service_account}@${var.cluster_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "default" {
  name   = "main_policy"
  role   = aws_iam_role.default.id
  policy = var.policy_json
}