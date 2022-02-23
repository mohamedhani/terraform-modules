data "tls_certificate" "eks_tls_certificate" {
  url = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "eks_idp" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_tls_certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
  tags = merge({
    "Name" = "${var.cluster_name}-idp"

  }, var.default_tags)
}

data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_idp.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:<NAMESPACE>:<SERVICE_ACCOUNT>"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_idp.arn]
      type        = "Federated"
    }
  }
}
