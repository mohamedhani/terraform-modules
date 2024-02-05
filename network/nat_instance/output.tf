output "instances_network_interface_ids" {

  value = aws_instance.nat_instance.*.primary_network_interface_id
}

output "nat_instance_ips" {
  value = aws_eip.nat_instance_eip.*.public_ip
}