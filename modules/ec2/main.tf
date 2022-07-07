data "aws_ami" "ami" {
  for_each = var.ec2_with_interfaces
  most_recent      = true
  owners = [ "amazon" ]

  filter {
    name   = "name"
    values = [each.value.instance_ami_name]
  }
}

resource "aws_network_interface" "ni" {
  for_each = var.ec2_with_interfaces
  subnet_id   = var.subnets[each.value.subnet_name]
  private_ips = each.value.addresses

  tags = {
    Name = each.value.aws_ni_name
  }
}

resource "aws_instance" "instance" {
  for_each = var.ec2_with_interfaces
  ami           = data.aws_ami.ami[each.key].id
  instance_type = each.value.instance_type
  availability_zone = each.value.availability_zone

  network_interface {
    network_interface_id = aws_network_interface.ni[each.key].id
    device_index         = 0
  }

  tags = {
    Name = each.key
  }
}