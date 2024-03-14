provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "lab2-ec2" {
  count                  = var.subnetCount
  ami                    = data.aws_ami.latest_ami.id
  instance_type          = var.defaultType
  availability_zone      = data.aws_availability_zones.zones.names[count.index]
  key_name               = var.defaultKey
  tags                   = { Name = "lab2-ec2-${count.index + 1}" }
  user_data              = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        yum install -y docker
        docker pull nginx:latest
        
        # Go to HTTPD index file location
        cd /var/www/html
        # Create custom HTML file for HTTP Server
        echo "Hello from HTTPD lab2-ec2-\${count.index + 1} and $(hostname -f) from Chance Page)" > index.html
        # Create custom HTML files for each NGINX server
        echo "Hello from NGINX1 lab2-ec2-\${count.index + 1} and $(hostname -f) from Chance Page" > /var/www/html/index1.html
        echo "Hello from NGINX2 lab2-ec2-\${count.index + 1} and $(hostname -f) from Chance Page" > /var/www/html/index2.html
        
        #Start and Enable services
        systemctl start docker
        systemctl enable docker
        systemctl restart httpd
        systemctl enable httpd
        # Run the first Nginx container with the first custom HTML file
        docker run -d -p 8080:80 -v /var/www/html/index1.html:/usr/share/nginx/html/index.html nginx
        # Run the second Nginx container with the second custom HTML file
        docker run -d -p 8081:80 -v /var/www/html/index2.html:/usr/share/nginx/html/index.html nginx
        EOF
  vpc_security_group_ids = [var.lab2Security.id]
  subnet_id              = var.lab2Subnets[count.index].id

}
output "ec2PublicIps" {
  description = "Public IPs of instances"
  value       = aws_instance.lab2-ec2[*].public_ip
}

output "httpd_website_urls" {
  description = "URLs for HTTPD websites"
  value       = [for i in aws_instance.lab2-ec2 : "http://${i.public_ip}"]
}

output "nginx1_website_urls" {
  description = "URLs for NGINX1 websites"
  value       = [for i in aws_instance.lab2-ec2 : "http://${i.public_ip}:8080"]
}

output "nginx2_website_urls" {
  description = "URLs for NGINX2 websites"
  value       = [for i in aws_instance.lab2-ec2 : "http://${i.public_ip}:8081"]
}