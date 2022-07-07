variable "vpc_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "subnet_config" {
  type = map(object({
    cidr = string
    route_table_name = string
    routes = list(string)
    security_group_name = string
    nat_required = bool
    nat_name = string
  }))
}