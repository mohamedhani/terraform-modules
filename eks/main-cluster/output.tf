output "eks_url" {
  value = aws_eks_cluster.main_cluster.endpoint
}
output "eks_assume_role_temp" {
  value = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json

}
output "node_group_sg_id" {
  value = aws_security_group.node_group_sg.id
}