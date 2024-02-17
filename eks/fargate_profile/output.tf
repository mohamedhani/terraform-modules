output "arn" {
  value = aws_eks_fargate_profile.default.arn
}

output "role_arn" {
  value = aws_iam_role.default.arn
}