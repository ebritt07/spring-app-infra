locals {
  region   = "us-east-1"
  org_name = "ebritt07"
}

provider "aws" {
  region = "${local.region}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.org_name}-tfstate"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${local.org_name}-app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}