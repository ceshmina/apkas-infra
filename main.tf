provider "aws" {
  region = "ap-northeast-1"
  profile = "apkas-terraform-dev"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  profile = "apkas-terraform-dev"
}

terraform {
  required_version = ">= 1.9.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.61.0"
    }
  }
  backend "s3" {
    bucket = "apkas-tfstate"
    region = "ap-northeast-1"
    profile = "apkas-terraform-dev"
    key = "apkas.tfstate"
  }
}
