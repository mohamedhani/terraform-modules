locals {
  iam_policies = [for _, src in module.dynamodb_policy : jsondecode(src.json)]
  iam_policy_statements = flatten([
    for policy in local.iam_policies : policy.Statement
  ])
  merged_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.iam_policy_statements
  })
}