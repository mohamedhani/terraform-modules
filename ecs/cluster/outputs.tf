output "arn" {
  value = aws_ecs_cluster.default.arn
}

output "namespace_arn" {
  value = aws_service_discovery_http_namespace.default.arn
}
