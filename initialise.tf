terraform {
  required_version = ">=1.2.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.5.0"
    }
  }

  backend "s3" {
    bucket = "295232774059-tfstate"
    key    = "aws-vpn-server/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}