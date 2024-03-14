variable "subnetCount" {}
variable "lab2Security" {}
variable "lab2Subnets" {}
variable "defaultKey"{
  type = string
  default = "awsKey"
}
variable "defaultType"{
  default = "t2.micro"
  type = string
}
data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }
}
data "aws_availability_zones" "zones" {
  state = "available"
}
data "aws_vpc" "default_vpc" {
  default = true
}