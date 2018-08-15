terraform {
  backend "s3" {
    bucket = "smava-state-dev"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
