# provider "aws" {
#   version = "~> 3.60.0"
#   region  = "us-east-2"
# }

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.27.0"
    }
  }
  required_version = ">= 0.14.9"
}

  
provider "aws" {
  profile = "default"
  region = "us-east-2"
}

# # cria vm 
# resource "aws_instance" "dev" {
#   count         = 1
#   ami           = var.namesMap["ubuntuServer20-04"]
#   instance_type = var.namesMap["tipoDaInstancia"]
#   key_name      = var.namesMap["nomeDaChaveDeAcesso"]
#   tags = {
#     Name = "dev${count.index}"
#   }
# }

# data "aws_availability_zones" "available" {}

# locals {
#   timestamp =  "${timestamp()}"  
# }


# resource "aws_subnet" "public-subnet1" {
#   vpc_id = "vpc-3ee59055"
#   cidr_block = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone = "${data.aws_availability_zones.available.names[0]}"
#   tags = {
#     Name = "subnet-hiago"
#     Owner = "240450717252"
#   }
# }

# resource "aws_subnet" "public-subnet2" {
#   vpc_id = "vpc-3ee59055"
#   cidr_block = "10.0.0.0/16"
#   map_public_ip_on_launch = true
#   availability_zone = "${data.aws_availability_zones.available.names[1]}"
#   tags = {
#     Name = "subnet-hiago"
#     Owner = "340450717253"
#   }
# }

# resource "aws_network_interface" "nic" {
#   subnet_id = "${aws_subnet.public-subnet1.id}"
#   security_groups = ["sg-ac4e72e1", "sg-0e77c8310c96a5e2c", "	sg-0bc9c6d863ddbb203"]
# }

resource "aws_launch_template" "as_conf" {
  name           = "Auto-Scaling-configuration-webCadastro2"
  image_id      = "ami-002a6c3decab778fc"
  instance_type = "t2.micro"
  security_group_names = ["default", "acesso-web", "loadbalancerHiago-aceso-web"]
  network_interfaces {
    device_index = 0
    network_interface_id = "eni-08f593f6eb987c9c2"
  }
    network_interfaces {
    device_index = 1
    network_interface_id = "eni-0fd5257600a0e0b33"
  }
    network_interfaces {
    device_index = 2
    network_interface_id = "eni-0c0eacf2d89765c4a"
  }
}


# #cria Auto Scaling Group

resource "aws_autoscaling_group" "auto_scaling" {
  availability_zones = ["us-east-2a", "us-east-2b"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.as_conf.id
    version = "$Latest"
  }
}



# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = "vpc-3ee59055"

#   ingress = [
#     {
#       description      = "TLS from VPC"
#       from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = ["170.150.242.221/32"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   ]

#   egress = [
#     {
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   ]

#   tags = {
#     Name = "allow_tls"
#   }
# }



# resource "aws_security_group" "acesso-ssh" {
#   name        = "acesso-ssh"
#   description = "acesso-ssh"
  

#   ingress =[
#     {
#       description = "Regra de acesso"
#       from_port        = 22
#       to_port          = 22
#       protocol         = "tcp"
#       cidr_blocks      = ["170.150.242.221/32"]
#       ipv6_cidr_blocks = ["::/0"]
      
#     }
#   ]

#     egress = [
#     {
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
      
#     }
# ]
# }