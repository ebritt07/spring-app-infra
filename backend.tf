terraform {
  backend "tf-remote-setup" {
    bucket         = "ebritt07-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ebritt07-app-state"
    encrypt        = true
  }
}