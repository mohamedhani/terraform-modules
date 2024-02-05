data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}
