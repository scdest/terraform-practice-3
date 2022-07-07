module "aws_vpc" {
  source     = "./modules/vpc"
  vpc_name = "my-vpc"
  cidr = "192.168.0.0/16"
  subnet_config = {  
    subnet1 = {
      cidr = "192.168.0.0/24"
      route_table_name = "table 1"
      routes = ["0.0.0.0/0", "192.168.1.0/24"]
      security_group_name = "sec group 1"
      nat_required = true
      nat_name = "nat1"
    }
    subnet2 = {
      cidr = "192.168.1.0/24"
      route_table_name = null
      routes = null
      security_group_name = "sec group 2"
      nat_required = false 
      nat_name = null
    }
    subnet3 = {
      cidr = "192.168.2.0/24"
      route_table_name = "table 3"
      routes = ["0.0.0.0/0", "192.168.0.0/24"]
      security_group_name = "sec group 3"
      nat_required = true
      nat_name = "nat3"
    }}
}

module "aws_ec2" {
  source     = "./modules/ec2"
  ec2_with_interfaces = {
    instance1 = {
        instance_ami_name = "*linux*"
        instance_type = "t2.micro"
        availability_zone = "us-east-1a"
        subnet_name = "subnet1"
        addresses = ["192.168.0.15", "192.168.0.16"]
        aws_ni_name = "ni1"
    }
    instance2 = {
        instance_ami_name = "*linux*"
        instance_type = "t2.micro"
        availability_zone = "us-east-1a"
        subnet_name = "subnet2"
        addresses = ["192.168.1.15", "192.168.1.16"]
        aws_ni_name = "ni2"
    }
    instance3 = {
        instance_ami_name = "*linux*"
        instance_type = "t2.micro"
        availability_zone = "us-east-1a"
        subnet_name = "subnet3"
        addresses = ["192.168.2.15", "192.168.2.16"]
        aws_ni_name = "ni3"
    }
  }
  subnets = module.aws_vpc.subnet_ids
}