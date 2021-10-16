terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.27.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

#cria secutity group
resource "aws_security_group" "acesso-ssh" {
  name        = "acesso-ssh"
  description = "acesso-ssh"
  # vpc_id      = ["vpc-3ee59055"]

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cdirs_acesso_remoto
    #   ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  tags = {
    Name = "ssh"
  }
}

#cria secutity group
resource "aws_security_group" "acesso-web" {
  name        = "acesso-web"
  description = "acesso-web"
  #   vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #   ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  tags = {
    Name = "acesso-web-80"
  }
}

#cria load balancer
resource "aws_elb" "load_balancer" {
  name               = "load-balancer-web-cadastro"
  availability_zones = ["us-east-2a", "us-east-2b"]
  security_groups    = ["${aws_security_group.acesso-web.id}", "${var.namesMap.securityGroupIdDefault}"]

  # access_logs {
  #   bucket        = "foo"
  #   bucket_prefix = "bar"
  #   interval      = 60
  # }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # listener {
  #   instance_port      = 8000
  #   instance_protocol  = "http"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  # }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # instances                   = [aws_instance.foo.id]
  # cross_zone_load_balancing   = true
  # idle_timeout                = 400
  # connection_draining         = true
  # connection_draining_timeout = 400

  tags = {
    Name = "load-balancer-web-cadastro"
  }
}

# cria auto scaling group configuration
resource "aws_launch_configuration" "autoscaling_conf" {
  name            = "auto_scaling_web_cadastro-configuration"
  image_id        = var.namesMap.webCadastro
  instance_type   = var.namesMap.tipoDaInstancia
  security_groups = ["${aws_security_group.acesso-ssh.id}", "${var.namesMap.securityGroupIdDefault}", "${aws_security_group.acesso-web.id}"]
  depends_on = [
    aws_security_group.acesso-ssh
  ]
}

#cria auto scaling group
resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "autoscaling_group"
  launch_configuration      = aws_launch_configuration.autoscaling_conf.name
  min_size                  = 2
  max_size                  = 2
  vpc_zone_identifier       = ["subnet-970499fc", "subnet-f092588d"]
  load_balancers            = ["load-balancer-web-cadastro"]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2

  lifecycle {
    create_before_destroy = true
  }
}