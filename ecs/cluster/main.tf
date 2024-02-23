resource "aws_ecs_cluster" "default" {
  name = "${var.project_name}-cluster"

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.default.arn
  }

  configuration {
    execute_command_configuration {
      log_configuration {
        cloud_watch_log_group_name = "/ecs/cluster/${var.project_name}-cluster"
      }
      logging = "OVERRIDE"
    }
  }

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
  depends_on = [aws_cloudwatch_log_group.default]
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/cluster/${var.project_name}-cluster"
  retention_in_days = var.logs_retentions
  tags              = var.default_tags
}

resource "aws_service_discovery_private_dns_namespace" "default" {
  name        = "${var.project_name}.local"
  description = "It is a service discovery namespace for ${var.project_name}-cluster"
  vpc         = var.vpc_id
}