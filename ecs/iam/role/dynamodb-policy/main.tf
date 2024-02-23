data "aws_iam_policy_document" "default" {
  statement {
    sid    = "${var.table_name}DynamoDbAcess"
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]

    resources = [
      "arn:aws:dynamodb:${var.region_name}:${var.account_id}:table/${var.table_name}",
      "arn:aws:dynamodb:${var.region_name}:${var.account_id}:table/${var.account_id}/index/*"
    ]
  }
}
