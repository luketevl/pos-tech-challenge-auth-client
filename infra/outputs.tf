output "api_url" {
  value = aws_apigatewayv2_stage.this.invoke_url
}

output "autoConfirm_lambda_arn" {
  value = aws_lambda_function.autoConfirm.arn
}