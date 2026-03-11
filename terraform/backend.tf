terraform {
  backend "s3" {
    bucket = "crepal-terraform-state"
    key    = "staging/terraform.tfstate"
    region = "eu-north-1"
  }
}
