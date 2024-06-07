resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "vapor_log_group" {
  name              = "/aws/lambda/vapor_lambda_function"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name = "lambda_execution_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
          aws_cloudwatch_log_group.vapor_log_group.arn,
          "${aws_cloudwatch_log_group.vapor_log_group.arn}:*"
        ]
      },
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:*:*:table/MainTable"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}

resource "aws_lambda_function" "vapor_lambda" {
  function_name = "vapor_lambda_function"
  filename      = "${path.module}/bootstrap.zip"
  handler       = "main"
  runtime       = "provided.al2023"
  architectures = [ "arm64" ]
  role          = aws_iam_role.lambda_execution_role.arn
  layers        = [aws_lambda_layer_version.libswift.arn, aws_lambda_layer_version.libcrypto.arn]

  environment {
    variables = {
      DYNAMODB_TABLE         = "MainTable"
      AWS_LAMBDA_LOG_GROUP   = "/aws/lambda/vapor_lambda_function"
      AWS_LAMBDA_LOG_STREAM  = "vapor_lambda_log_stream"
      LAMBDA_ENABLED         = ""
    }
  }

  source_code_hash = filebase64sha256("${path.module}/bootstrap.zip")
}

resource "aws_lambda_layer_version" "libswift" {
  filename   = "${path.module}/layers/libswift.zip"
  layer_name = "libswift"
  compatible_runtimes = ["provided.al2023"]
  compatible_architectures = ["arm64"]

  source_code_hash = filebase64sha256("${path.module}/layers/libswift.zip")
}

resource "aws_lambda_layer_version" "libcrypto" {
  filename   = "${path.module}/layers/libcrypto.zip"
  layer_name = "libcrypto"
  compatible_runtimes = ["provided.al2023"]
  compatible_architectures = ["arm64"]

  source_code_hash = filebase64sha256("${path.module}/layers/libcrypto.zip")
}

resource "aws_lambda_function_url" "vapor_lambda_url" {
  function_name       = aws_lambda_function.vapor_lambda.function_name
  authorization_type  = "NONE"
}

resource "aws_lambda_permission" "allow_public_access" {
  statement_id  = "AllowPublicAccess"
  action        = "lambda:InvokeFunctionUrl"
  function_name = aws_lambda_function.vapor_lambda.function_name
  principal     = "*"
  function_url_auth_type = aws_lambda_function_url.vapor_lambda_url.authorization_type
}
