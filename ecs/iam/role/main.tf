data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = "${var.task_name}@${var.cluster_name}-role"
  path               = "/ecs/task-roles/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "default" {
  role   = aws_iam_role.default.id
  name   = "dynamodb-policies"
  policy = local.merged_policy
}