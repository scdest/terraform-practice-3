variable "ec2_with_interfaces" {
  type = map(object({
    instance_ami_name = string
    instance_type = string
    availability_zone = string,
    subnet_name = string
    addresses = list(string)
    aws_ni_name = string
  }))
}

variable "subnets" {
  type = map(string)
}