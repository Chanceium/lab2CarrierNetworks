data "aws_ami" "latest_ami"{
    most_recent = true
    owners = ["amazon"]
    filter {
      name = "name"
      values = ["amzn2-ami-*-x86_64-gp2"]
    }
}
data "aws_availability_zones" "zones" {
  state = "available"
}
data "aws_vpc" "default_vpc" {
  default = true
}