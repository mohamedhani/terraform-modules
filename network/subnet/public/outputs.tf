output "ids" {
  value = [for s in aws_subnet.default : s.id]
}

output "natgateway_ids" {
  value = [for ng in module.nat_gateway : ng.id]
}