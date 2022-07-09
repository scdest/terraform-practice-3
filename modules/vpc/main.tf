data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = data.aws_vpc.vpc.id
  for_each = var.subnet_config
  cidr_block = each.value.cidr
  tags = {
    Name = each.key
  }
}

locals {
  nats = { for k, v in var.subnet_config :  k => v if v.nat_required == true }
}

resource "aws_nat_gateway" "nat" {
  for_each = local.nats
  subnet_id = aws_subnet.subnet[each.key].id
  connectivity_type = "private"

  tags = {
    Name = each.value.nat_name
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = data.aws_vpc.vpc.id
  for_each = local.nats

  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block = route.value
      gateway_id = aws_nat_gateway.nat[each.key].id
    }
  }

  tags = {
    Name = each.value.route_table_name
  }
}

resource "aws_security_group" "sec_group" {
  for_each = var.subnet_config
  name = each.value.security_group_name
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = each.value.security_group_name
  }
}