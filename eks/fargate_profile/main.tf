resource "aws_eks_fargate_profile" "default" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "${var.cluster_name}-${var.name}"
  pod_execution_role_arn = aws_iam_role.default.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = var.namespace
    labels    = var.labels
  }

  tags = merge({ "Name" = "${var.cluster_name}-${var.name}" }, var.default_tags)
}