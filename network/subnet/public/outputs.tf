output "prublic_subnets_id" {
  value = aws_subnet.subnet.*.id
}
output "instances_network_interface_ids" {
  value = module.nat_instances.instances_network_interface_ids
  
}