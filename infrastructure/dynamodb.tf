resource "aws_dynamodb_table" "main_table" {
  name           = "MainTable"
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = "PK"
  range_key      = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  attribute {
    name = "GSI1PK"
    type = "S"
  }

  attribute {
    name = "GSI1SK"
    type = "S"
  }

  attribute {
    name = "GSI2PK"
    type = "S"
  }

  attribute {
    name = "GSI2SK"
    type = "S"
  }

  global_secondary_index {
    name            = "GSI1"
    hash_key        = "GSI1PK"
    range_key       = "GSI1SK"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "GSI2"
    hash_key        = "GSI2PK"
    range_key       = "GSI2SK"
    projection_type = "ALL"
  }

  tags = {
    Environment = "dev"
    Project     = "Pomodoro-app"
  }
}

resource "aws_iam_user" "dynamodb_user" {
  name = "dynamodb_user"
}

resource "aws_iam_user_policy" "dynamodb_user_policy" {
  name = "dynamodb_user_policy"
  user = aws_iam_user.dynamodb_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
        Resource = aws_dynamodb_table.main_table.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "dynamodb_access_key" {
  user = aws_iam_user.dynamodb_user.name
}
