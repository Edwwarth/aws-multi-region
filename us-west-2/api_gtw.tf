resource "aws_api_gateway_rest_api" "ed_gtw" {
  name = "ed-gtw"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "ed_gtw" {
  rest_api_id = aws_api_gateway_rest_api.ed_gtw.id
  stage_name = "development"

  depends_on = [aws_api_gateway_integration.ed_root]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "ed_gtw" {
  deployment_id = aws_api_gateway_deployment.ed_gtw.id
  rest_api_id   = aws_api_gateway_rest_api.ed_gtw.id
  stage_name    = "development"
}

resource "aws_api_gateway_domain_name" "ed_gtw" {
  certificate_arn = "arn:aws:acm:us-east-1:739354512008:certificate/b77811a8-e5fa-4d64-b951-ca9422323e4c"
  domain_name = "ed-test-api.sg-faas-plurall.com"
}

resource "aws_api_gateway_base_path_mapping" "ed_gtw" {
  api_id = aws_api_gateway_rest_api.ed_gtw.id
  stage_name = aws_api_gateway_stage.ed_gtw.stage_name
  domain_name = aws_api_gateway_domain_name.ed_gtw.domain_name
}

resource "aws_api_gateway_method" "ed_root" {
  rest_api_id = aws_api_gateway_rest_api.ed_gtw.id
  resource_id = aws_api_gateway_rest_api.ed_gtw.root_resource_id
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ed_root" {
  rest_api_id = aws_api_gateway_rest_api.ed_gtw.id
  resource_id = aws_api_gateway_method.ed_root.resource_id
  http_method = aws_api_gateway_method.ed_root.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.ed_lambda.invoke_arn
}
