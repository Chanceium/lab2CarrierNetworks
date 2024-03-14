module "ec2" {
  source       = "./ec2"
  subnetCount  = var.subnetCount
  lab2Security = module.security.lab2Security
  lab2Subnets  = module.vpc.lab2Subnets
  
  
}
module "security" {
  source  = "./security"
  lab2VPC = module.vpc.lab2VPC
}
module "vpc" {
  source      = "./vpc"
  subnetCount = var.subnetCount
}
variable "subnetCount" {
  description = "The number of subnets to be created."
  type        = number
  default     = 4
}
output "publicIps" {
  value = flatten([
    for ip in module.ec2.ec2PublicIps : [
      "EC2 HTTPD  http://${ip}:80",
      "EC2 NGINX1 http://${ip}:8080",
      "EC2 NGINX2 http://${ip}:8081"
    ]
  ])
}


