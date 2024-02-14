output "role_arn" {
  value = aws_iam_role.default.arn
}

output "profile_arn" {
  value = aws_iam_instance_profile.default.arn
}