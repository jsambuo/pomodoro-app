output "url" {
  value = aws_apigatewayv2_stage.test_stage.invoke_url
}

output "client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}
