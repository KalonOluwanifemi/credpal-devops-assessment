terraform {
  backend "s3" {
    bucket = "credpal-terraform-state"
    key    = "staging/terraform.tfstate"
    region = "eu-north-1"
  }
}
