locals {
  policies = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "excution_role" {
  name               = "${var.task_name}@${var.cluster_name}-excution-role"
  path               = "/ecs/task-roles/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "excution_role_policy_attachement" {
  for_each   = toset(local.policies)
  role       = aws_iam_role.excution_role.name
  policy_arn = each.value
}