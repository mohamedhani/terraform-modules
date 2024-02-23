resource "aws_ecs_cluster" "default" {
  name = var.cluster_name
  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.default.arn
  }
  configuration {
    execute_command_configuration {
      log_configuration {
        cloud_watch_log_group_name = "/ecs/cluster/${var.cluster_name}"
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

resource "aws_service_discovery_http_namespace" "default" {
  name        = var.cluster_name
  description = "It is a service discovery namespace for ${var.cluster_name} ecs cluster"
  tags        = var.default_tags
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/cluster/${var.cluster_name}"
  retention_in_days = var.logs_retentions
  tags              = var.default_tags
}
