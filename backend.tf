terraform {
  backend "s3" {
    bucket         = "${local.org_name}-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "${local.org_name}-app-state"
    encrypt        = true
  }
}