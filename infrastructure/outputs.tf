output "url" {
  value = aws_apigatewayv2_stage.test_stage.invoke_url
}

output "client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "dynamodb_access_key_id" {
  value = aws_iam_access_key.dynamodb_access_key.id
}

output "dynamodb_secret_access_key" {
  value = aws_iam_access_key.dynamodb_access_key.secret
  sensitive = true
}
