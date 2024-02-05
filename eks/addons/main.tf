data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_eks_addon_version" "addon_version" {
  addon_name         = var.addon_name
  kubernetes_version = data.aws_eks_cluster.eks_cluster.version
  most_recent        = true
}

resource "aws_eks_addon" "default" {
  cluster_name = var.cluster_name
  addon_name   = var.addon_name
}