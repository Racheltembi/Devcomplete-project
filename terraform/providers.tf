terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}
provider "aws" {
  region = "eu-north-1"
  profile = "default"
}

