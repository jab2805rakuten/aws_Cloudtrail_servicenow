resource "aws_iam_role" "lambda_servicenow" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_servicenow" {
  policy_arn = "${aws_iam_policy.lambda_servicenow.arn}"
  role = "${aws_iam_role.lambda_servicenow.name}"
}

resource "aws_iam_policy" "lambda_servicenow" {
  policy = "${data.aws_iam_policy_document.lambda_servicenow.json}"
}

data "aws_iam_policy_document" "lambda_servicenow" {
  statement {
    sid       = "AllowSQSPermissions"
    effect    = "Allow"
    resources = ["arn:aws:sqs:*"]

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
  }

  statement {
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:${var.region}:*:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }
  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  } 

  statement {
    sid       = "Allows3"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]
    actions = [ "s3:*" ]
  }
  statement {
    sid       = "Allowdynmodb"
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:${var.region}:${var.account}:*"]
    actions = [ 
       "dynamodb:DeleteItem", 
       "dynamodb:GetItem",
       "dynamodb:PutItem",
       "dynamodb:Scan",
       "dynamodb:UpdateItem"
    ]
  }
  statement {
    sid       = "Allowsns"
    effect    = "Allow"
    resources = ["arn:aws:sns:*:*:*"]
    actions = [ "sns:Publish" ]
  }
}

