variable "namesMap" {
  type = map(string)
  default = {
    "webCadastro"            = "ami-002a6c3decab778fc" #ami da imagem criada
    "tipoDaInstancia"        = "t2.micro"
    "nomeDaChaveDeAcesso"    = "terraform-aws"
    "securityGroupIdDefault" = "sg-ac4e72e1"
  }
}

variable "meu_ip" {
  type    = list(string)
  default = ["170.150.241.232/32", "170.150.241.232/32"]
}


variable "availability_zones" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}