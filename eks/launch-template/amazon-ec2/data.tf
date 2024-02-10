data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_ssm_parameter" "ami_id" {
  name = "/aws/service/eks/optimized-ami/${data.aws_eks_cluster.eks_cluster.version}/amazon-linux-2/recommended/image_id"
}