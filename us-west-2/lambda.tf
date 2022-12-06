data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid = "1"
    actions =  [
      "ssm:GetParameter"
    ]


    resources =  [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "assume_role_policy"  {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions =  [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_lambda_function" "ed_lambda" {
  function_name = "ed_multi_cl_lambda"
  memory_size   = 128
  timeout       = 5

  role          = aws_iam_role.role.arn
  handler       = "lambda_function.init"
  runtime       = "python3.9"
  s3_bucket     = "plurall-devops"
  s3_key        = "lambdas/devops/default/lambda.zip"
}

resource "aws_iam_role" "role" {
  name = "ed_lambda_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "policy" {
  name = "ed_lambda_role_policy"
  role = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}
