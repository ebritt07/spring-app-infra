module "lambda" {
  source       = "./modules/lambda"
  bucket_name  = var.bucket_name
  lambda_name  = var.s3_logger_lambda_name
  bucket_arn   = module.s3.bucket_arn
  zip_path     = var.zip_path
}

module "s3" {
  source            = "./modules/s3_bucket"
  bucket_name       = var.bucket_name
  lambda_arns       = [module.lambda.lambda_arn]
}