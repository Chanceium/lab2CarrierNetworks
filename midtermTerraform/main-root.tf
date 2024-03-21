provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "midtermEC2" {
    count             = 2
    ami               = data.aws_ami.latest_ami.id
    instance_type     = "t2.micro"
    availability_zone = data.aws_availability_zones.zones.names[count.index]
    key_name          = "awsKey"
    tags              = { Name = "midtermEC2" }
    user_data         = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        cd /var/www/html
        echo "Chance Page $(hostname -f)" > index.html
        systemctl restart httpd
        systemctl enable httpd
        EOF
    vpc_security_group_ids = [aws_security_group.midterm_security.id]
    
}



//SECURITY SSH
resource "aws_security_group" "midterm_security" {
  name   = "midterm_security"
  vpc_id = data.aws_vpc.default_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags             = { Name = "midterm_security" }
}

