provider "aws" {
  region = var.aws_region
}

# S3 Bucket for storing test reports
resource "aws_s3_bucket" "test_reports" {
  bucket = var.s3_bucket_name
  acl    = "private"
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach policy to IAM Role
resource "aws_iam_policy_attachment" "lambda_policy_attach" {
  name       = "lambda_policy_attach"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"
}

# AWS Lambda function for test execution
resource "aws_lambda_function" "test_runner" {
  filename      = "lambda_test_runner.zip"
  function_name = "AWS_Test_Automation"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = filebase64sha256("lambda_test_runner.zip")

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.test_reports.bucket
    }
  }
}

# CloudWatch Logs for monitoring Lambda execution
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.test_runner.function_name}"
  retention_in_days = 7
}

# Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for storing test reports"
  type        = string
  default     = "aws-test-automation-reports"
}

# Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.test_reports.bucket
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.test_runner.arn
}
