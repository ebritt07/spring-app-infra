data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../python/lambda/${var.lambda_name}"
  output_path = "${path.module}/../../${var.zip_path}/${var.lambda_name}.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.bucket_name}-${var.lambda_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "log_s3_event" {
  function_name    = "${var.bucket_name}-${var.lambda_name}"
  role             = aws_iam_role.lambda_exec.arn
  runtime          = "python3.12"
  handler          = "main.handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}