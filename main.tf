provider "aws" {
  region = var.region
}

module "lambda" {
  source      = "./modules/lambda"
  bucket_name = var.bucket_name
  lambda_name = var.s3_logger_lambda_name
  zip_path    = var.zip_path
}

module "s3" {
  source      = "./modules/s3_bucket"
  bucket_name = var.bucket_name
  lambda_arns = {
    s3_logger = module.lambda.lambda_arn
  }
}

module "spring_app_ecr_repo" {
  source        = "./modules/ecr"
  ecr_repo_name = var.spring_app_ecr_repo
}

# module "network" {
#   source              = "./modules/network"
#   region              = var.region
#   spring_app_ecr_repo = var.spring_app_ecr_repo
#   spring_app_version  = var.spring_app_version
#   aws_account_id      = var.aws_account_id
# }