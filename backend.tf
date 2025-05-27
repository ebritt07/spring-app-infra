terraform {
  backend "s3" {
    bucket         = "${var.org_name}-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "${var.org_name}-app-state"
    encrypt        = true
  }
}