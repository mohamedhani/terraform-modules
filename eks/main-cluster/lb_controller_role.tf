# these resources for lb_controller
# it will created only when enable_lb_controller variable == true
/*
locals {
  oidc_url = trimprefix( aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer,"https://")
}
data "aws_iam_policy_document" "lb_controller_assume_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["${aws_iam_openid_connect_provider.eks_idp.arn}"]

    }
    condition {
      test = "StringEquals"
      variable = "${local.oidc_url}:aud"
      values = ["sts.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      variable = "${local.oidc_url}:sub"
      values = ["system:serviceaccount:${var.lb_controller.namespace}:${var.lb_controller.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "lb_controller_role" {
  for_each = toset(var.enable_lb_controller ? ["enabled"]: [])
  name = "LoadBalancerControllerRole"
  assume_role_policy = data.aws_iam_policy_document.lb_controller_assume_policy.json

}


resource "aws_iam_role_policy" "lb_controller_iam_policy_attachment" {
 for_each = toset(var.enable_lb_controller ? ["enabled"]: [])
  name = "LoadBalancerControllerPolicy"
  
  role = aws_iam_role.lb_controller_role["enabled"].id
  policy = file("${path.module}/policies/lb_iam_polcy.json")

}
*/