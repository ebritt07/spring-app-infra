resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "lambda_function" {
    for_each = var.lambda_arns
    content {
      lambda_function_arn = lambda_function.value
      events              = ["s3:ObjectCreated:*"]
    }
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_lambda_permission" "allow_s3" {
  for_each = toset(var.lambda_arns)

  statement_id  = "AllowExecutionFromS3-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this.arn
}