output "ids" {
  value = [for s in aws_subnet.default : s.id]
}
