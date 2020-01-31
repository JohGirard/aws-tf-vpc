provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    key = "test/network.tfstate"
  }
  required_version = ">= 0.12"
}
