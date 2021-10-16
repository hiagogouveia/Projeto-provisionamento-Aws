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

#cria load balancer
resource "aws_elb" "load_balancer" {
  name               = "load-balancer-web-cadastro"
  availability_zones = var.availability_zones
  security_groups    = ["${aws_security_group.acesso-web.id}", "${var.namesMap.securityGroupIdDefault}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

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