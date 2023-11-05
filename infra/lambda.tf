data "archive_file" "login_artefact" {
  output_path = "files/login_artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/login/index.js"
}

resource "aws_lambda_function" "login" {
  function_name    = "login"
  handler          = "index.handler"
  role             = aws_iam_role.login_lambda.arn
  runtime          = "nodejs18.x"
  filename         = data.archive_file.login_artefact.output_path
  source_code_hash = data.archive_file.login_artefact.output_base64sha512

  timeout     = 5
  memory_size = 128

  environment {
    variables = {

    }
  }
}

resource "aws_lambda_permission" "api" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}