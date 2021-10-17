#cria secutity group
resource "aws_security_group" "acesso-ssh" {
  name        = "acesso-ssh"
  description = "acesso-ssh"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.meu_ip
  }

  tags = {
    Name = "ssh"
  }
}

#cria secutity group
resource "aws_security_group" "acesso-web" {
  name        = "acesso-web"
  description = "acesso-web"

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "acesso-web-80"
  }
}