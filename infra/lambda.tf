data "archive_file" "login_artefact" {
  output_path = "files/login_artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/login/index.js"
}

data "archive_file" "autoConfirm_artefact" {
  output_path = "files/autoConfirm_artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/autoConfirm/index.js"
}


resource "aws_lambda_function" "login" {
  function_name    = "login"
  handler          = "index.handler"
  role             = aws_iam_role.login_lambda.arn
  runtime          = "nodejs18.x"
  filename         = data.archive_file.login_artefact.output_path
  source_code_hash = data.archive_file.login_artefact.output_base64sha512

  timeout     = 2
  memory_size = 128

  environment {
    variables = {
      COGNITO_CLIENT_ID     = var.aws_cognito_client_id
      COGNITO_CLIENT_SECRET = var.aws_cognito_client_secret
    }
  }
}

resource "aws_lambda_function" "autoConfirm" {
  function_name    = "autoConfirm"
  handler          = "index.handler"
  role             = aws_iam_role.login_lambda.arn
  runtime          = "nodejs18.x"
  filename         = data.archive_file.autoConfirm_artefact.output_path
  source_code_hash = data.archive_file.autoConfirm_artefact.output_base64sha512
  timeout     = 2
  memory_size = 128
}

resource "aws_lambda_permission" "api" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*"
}

resource "aws_lambda_permission" "pre_sign_up" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.autoConfirm.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:${var.aws_region}:${var.aws_account_id}:userpool/${var.aws_cognito_user_pool}/*/*"
  depends_on = [ aws_lambda_function.autoConfirm ]
}