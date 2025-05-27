terraform {
  backend "s3" {
    bucket = "terraform-s3-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}