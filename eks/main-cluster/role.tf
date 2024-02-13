locals {
  eks_role_policies = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
}
#### EKS Cluster Role ####
data "aws_iam_policy_document" "eks_assume_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_role" {
  name               = "${var.cluster_name}-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_policy.json
  tags = merge({
    "Name" = "${var.cluster_name}-role"
  }, var.default_tags)
}

resource "aws_iam_role_policy_attachment" "eks_role_policy_attcement" {
  for_each   = toset(local.eks_role_policies)
  policy_arn = each.value
  role       = aws_iam_role.eks_role.name
}

#### Worker Node Role ####
locals {
  ng_ec2_policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "worker_node_role" {
  name               = "${var.cluster_name}-worker-node-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
  tags               = var.default_tags
}

resource "aws_iam_role_policy_attachment" "worker_node_role_policy_attachment" {
  for_each   = toset(local.ng_ec2_policies)
  policy_arn = each.value
  role       = aws_iam_role.worker_node_role.name
}

resource "aws_iam_instance_profile" "worker_node_instance_profile" {
  name = "${var.cluster_name}-worker-node-profile"
  role = aws_iam_role.worker_node_role.name
}
