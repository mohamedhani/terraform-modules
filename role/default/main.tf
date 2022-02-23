locals {
  full_name = "${var.project_name}-${var.role_name}"
}

resource "aws_iam_policy" "main_policy" {
  name   = "${local.full_name}-policy"
  path   = "/"
  policy = jsonencode(var.policy_json)

}

resource "aws_iam_role" "main_role" {
  name = "${local.full_name}-role"

  assume_role_policy = var.assumed_policy_json
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  policy_arn = aws_iam_policy.main_policy.arn
  role       = aws_iam_role.main_role.name
}

