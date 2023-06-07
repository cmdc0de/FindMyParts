provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "lambda_role" {
  name               = "eoc_lambda_role"
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

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "dynamodb:*"
    ]

    resources = [
      "arn:aws:logs:*:*:*",
      "arn:aws:dynamodb:*:*:*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name   = "aws_iam_policy_for_terraform_aws_lambda_role"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}


resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_the_python_code" {
  type         = "zip"
  source_file  = "storage_device_type.py"
  output_path  = "storage_device_type.zip"
}

resource "aws_lambda_function" "storage_device_type_put_item" {
  filename      = "storage_device_type.zip"
  function_name = "storage_device_type_put_item"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.put_item_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "storage_device_type_delete_item" {
  filename      = "storage_device_type.zip"
  function_name = "storage_device_type_delete_item"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.delete_item_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "storage_device_type_scan" {
  filename      = "storage_device_type.zip"
  function_name = "storage_device_type_scan"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.scan_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

