terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  access_key = ""
  secret_key = ""
}