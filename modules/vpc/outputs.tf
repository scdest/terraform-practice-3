output "subnet_ids" {
  value = {for key, value in aws_subnet.subnet : key => value.id}
}

output "nat_ids" {
  value = {for key, value in aws_nat_gateway.nat : key => value.id}
}