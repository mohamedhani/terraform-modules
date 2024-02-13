output "eks_url" {
  value = aws_eks_cluster.main_cluster.endpoint
}

output "eks_arn" {
  value = aws_eks_cluster.main_cluster.arn
}

output "ng_sg_id" {
  value = aws_security_group.node_group_sg.id
}

output "ng_worker_role_arn" {
  value = aws_iam_role.worker_node_role.arn
}

output "worker_node_profile_arn" {
  value = aws_iam_instance_profile.worker_node_instance_profile.arn
}