#Create the VPC
resource "aws_vpc" "lab2-vpcA-tf" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "lab2-vpcA-tf" }
}
#Create the internet gateway
resource "aws_internet_gateway" "lab2-igwA-tf" {
    vpc_id = aws_vpc.lab2-vpcA-tf.id
    tags = {Name = "lab2-igwA-tf"}
}
#Create the public subnet
data "aws_availability_zones" "available" {}

#Create 4 subnets incrementing with the count for the cidr blocks.
resource "aws_subnet" "lab2-vpcA-tf" {
  count                   = var.subnetCount
  vpc_id                  = aws_vpc.lab2-vpcA-tf.id
  cidr_block              = "192.168.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "lab2-vpcA-${count.index + 1}-tf"
  }
}

#Create public routing table
resource "aws_route_table" "lab2-vpcA-publicRT-tf" {
    vpc_id = aws_vpc.lab2-vpcA-tf.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lab2-igwA-tf.id
    }
    
    tags = {Name = "lab2-vpcA-publicRT-tf"}
}
resource "aws_route_table_association" "lab2-vpcA-publicRA-tf" {
  count          = length(aws_subnet.lab2-vpcA-tf)
  subnet_id      = aws_subnet.lab2-vpcA-tf[count.index].id
  route_table_id = aws_route_table.lab2-vpcA-publicRT-tf.id
}
output "lab2VPC" {
  value = resource.aws_vpc.lab2-vpcA-tf
}
output "lab2Subnets" {
  value = resource.aws_subnet.lab2-vpcA-tf
}