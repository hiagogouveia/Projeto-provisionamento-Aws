variable "namesMap" {
  type = map(string)
  default = {
    "webCadastro"            = "ami-002a6c3decab778fc"
    "tipoDaInstancia"        = "t2.micro"
    "nomeDaChaveDeAcesso"    = "terraform-aws"
    "securityGroupIdDefault" = "sg-ac4e72e1"
  }
}

variable "cdirs_acesso_remoto" {
  type    = list(string)
  default = ["170.150.241.232/32", "170.150.241.232/32"]
}

variable "id_subnet_default" {
  type    = list(string)
  default = ["170.150.241.232/32", "170.150.241.232/32"]
}