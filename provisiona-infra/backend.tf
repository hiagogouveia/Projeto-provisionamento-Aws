terraform {
  backend "s3" {
    bucket         = "backend-tf-hiago"
    key            = "azure/terraform.tfstate"
    region         = "us-east-2"
  }
}
