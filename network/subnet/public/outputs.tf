output "prublic_subnets_id" {
  value = aws_subnet.default.*.id
}