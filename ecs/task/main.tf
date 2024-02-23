data "aws_region" "current" {}

resource "aws_ecs_task_definition" "default" {
  family                   = "${var.cluster_name}-${var.task_name}-task"
  requires_compatibilities = [var.type]
  network_mode             = "awsvpc"

  execution_role_arn    = aws_iam_role.excution_role.arn
  task_role_arn         = var.role_arn
  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = jsonencode(local.container_definitions)

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  tags = var.default_tags

  depends_on = [
    aws_iam_role_policy_attachment.excution_role_policy_attachement,
  aws_cloudwatch_log_group.default]
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/${var.cluster_name}-${var.task_name}-task"
  retention_in_days = var.logs_retentions
  tags              = var.default_tags
}
