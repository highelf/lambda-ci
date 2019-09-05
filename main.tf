// Provider configuration
provider "aws" {
  region = "${var.region}"
}

// S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket}"
  acl    = "private"
}

resource "aws_iam_policy" "s3_policy" {
  name = "PushToS3Policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name = "DeployLambdaPolicy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:UpdateFunctionCode",
        "lambda:PublishVersion",
        "lambda:UpdateAlias"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


// Lambda function
resource "aws_lambda_function" "function" {
  filename      = "deployment.zip"
  function_name = "Fibonacci"
  role          = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  handler       = "main"
  runtime       = "go1.x"
}
