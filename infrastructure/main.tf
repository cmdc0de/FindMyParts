provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "lambda_role" {
  name               = "eoc_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
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
      "arn:aws:dynamodb:*:*:*",
      "arn:aws:lambda:*:*:*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name   = "aws_iam_policy_for_terraform_aws_lambda_role"
  path   = "/fmp/"
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

resource "aws_lambda_function" "put_storage_device_type_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "put_storage_device_type_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.put_storage_device_type_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "delete_storage_device_type_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "delete_storage_device_type_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.delete_storage_device_type_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "scan_storage_device_type_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "scan_storage_device_type_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.scan_storage_device_type_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "put_storage_instance_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "put_storage_instance_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.put_storage_instance_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "delete_storage_instance_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "delete_storage_instance_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.delete_storage_instance_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "scan_storage_instance_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "scan_storage_instance_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.scan_storage_instance_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "put_component_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "put_component_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.put_component_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "delete_component_type_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "delete_component_type_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.delete_component_type_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function" "scan_component_type_lambda_handler" {
  filename      = "storage_device_type.zip"
  function_name = "scan_component_type_lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "storage_device_type.scan_component_type_lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.zip_the_python_code.output_sha
}

resource "aws_lambda_function_url" "url_for_scan_storage_device_type_lambda_handler" {
  function_name      = aws_lambda_function.scan_storage_device_type_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}


resource "aws_lambda_function_url" "url_for_put_storage_device_type_lambda_handler" {
  function_name      = aws_lambda_function.put_storage_device_type_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "url_for_delete_storage_device_type_lambda_handler" {
  function_name      = aws_lambda_function.delete_storage_device_type_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "url_for_scan_storage_instance_lambda_handler" {
  function_name      = aws_lambda_function.scan_storage_instance_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "url_for_storage_instance_type_delete_item" {
  function_name      = aws_lambda_function.delete_storage_instance_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "url_for_storage_instance_type_put_item" {
  function_name      = aws_lambda_function.put_storage_instance_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "url_for_scan_component_type_lambda_handler" {
  function_name      = aws_lambda_function.scan_component_type_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "url_for_delete_component_type_lambda_handler" {
  function_name      = aws_lambda_function.delete_component_type_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_lambda_function_url" "url_for_put_component_lambda_handler" {
  function_name      = aws_lambda_function.put_component_lambda_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

