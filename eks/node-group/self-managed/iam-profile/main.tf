
locals {
  policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.default_tags
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each   = toset(local.policies)
  policy_arn = each.value
  role       = aws_iam_role.default.name
}

resource "aws_iam_instance_profile" "default" {
  name = var.name
  path = "/eks-node-roles/"
  role = aws_iam_role.default.name
  tags = var.default_tags
}
