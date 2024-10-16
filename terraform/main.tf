terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.29.0"
        }   
    }
    required_version = ">= 1.2.0"
}

resource "aws_instance" "server" {
    ami                   = "ami-042e76978adeb8c48"
    instance_type         = "t2.micro"
    subnet_id              = "${aws_subnet.new_public_subnet_2a.id}"
    vpc_security_group_ids = [aws_security_group.instance.id]
    key_name  = "nuri"
    tags = {  
        Name = "nuri"
    }
}

resource "aws_security_group" "instance" {
    name = var.security_group_name
    vpc_id = "${aws_vpc.new_vpc.id}"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["192.168.0.0/32"]
    }
    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "terraform-sg"
    }
}

variable "security_group_name" {
    description = "The name of the security group"
    type        = string
    default     = "terraform-example-instance"
}

output "public_ip" {
    value       = aws_instance.server.public_ip
    description = "The public IP of the Instance"
}

output "public_dns" {
  value       = aws_instance.server.public_dns
  description = "The Public dns of the Instance"
}

output "private_ip" {
  value       = aws_instance.server.private_ip
  description = "The Private_ip of the Instance"
}