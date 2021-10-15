variable "namesMap" {
  type = map(any)
  default = {
    "ubuntuServer20-04"   = "ami-00399ec92321828f5"
    "tipoDaInstancia"     = "t2.micro"
    "nomeDaChaveDeAcesso" = "terraform-aws"
  }
}

# variable "namesMap" {
#   type = list(any)
#   default = {
#     ["170.150.242.221/32,"]
#   }
# }