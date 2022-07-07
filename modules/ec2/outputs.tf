output "instance_ids" {
  value = [{for key, value in aws_instance.instance : key => value.id}]
}

output "ni_ids" {
  value = [{for key, value in aws_network_interface.ni : key => value.id}]
}