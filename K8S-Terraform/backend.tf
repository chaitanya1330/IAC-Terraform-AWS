terraform {
  backend "s3" {
    bucket = "chayram"
    key    = "terraform/state"
    region = "ap-south-1"
  }
}