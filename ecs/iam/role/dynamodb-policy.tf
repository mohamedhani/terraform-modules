module "dynamodb_policy" {
  for_each = toset(var.configs.dynamodb_tables)

  source      = "./dynamodb-policy"
  account_id  = data.aws_caller_identity.current.account_id
  region_name = data.aws_region.current.name
  table_name  = each.value
}