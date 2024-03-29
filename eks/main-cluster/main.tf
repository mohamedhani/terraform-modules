resource "aws_eks_cluster" "main_cluster" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.default.arn
  enabled_cluster_log_types = var.log_types
  version                   = var.eks_cluster_version

  vpc_config {
    endpoint_private_access = var.eks_private_access
    endpoint_public_access  = var.eks_public_access
    public_access_cidrs     = var.eks_public_access == true ? var.public_access_cidrs : []
    subnet_ids              = var.private_subnets_ids
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_cidr
    ip_family         = "ipv4"
  }

  tags = merge({
    "Name" = var.cluster_name
  }, var.default_tags)
  depends_on = [
    aws_cloudwatch_log_group.cloud_watch_group,
    aws_iam_role_policy_attachment.default
  ]
}

resource "aws_cloudwatch_log_group" "cloud_watch_group" {
  count             = length(var.log_types) > 0 ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

}
