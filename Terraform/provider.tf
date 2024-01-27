terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  profile = "Chaitanya"
}

provider "aws" {
  profile = "Chaitanya"
  region  = "us-east-2"
  alias   = "use-2"
}