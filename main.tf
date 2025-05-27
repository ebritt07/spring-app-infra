provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.bucket_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "log_s3_event" {
  function_name = "${var.bucket_name}-log-events"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.12"
  handler       = "main.handler"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/log_s3_event"
  output_path = "${path.module}/lambda_log_event.zip"
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_s3_event.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this.arn
}

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.log_s3_event.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}