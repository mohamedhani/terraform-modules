output "eks_url" {
  value = aws_eks_cluster.main_cluster.endpoint
}

output "arn" {
  value = aws_eks_cluster.main_cluster.arn
}

output "ng_sg_id" {
  value = aws_security_group.node_group_sg.id
}
