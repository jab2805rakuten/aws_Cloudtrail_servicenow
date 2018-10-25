data "archive_file" "lambda_servicenow" {
  type        = "zip"
  source_file = "${path.module}/lambda_servicenow.py"
  output_path = "${path.module}/lambda_servicenow.zip"
}

resource "aws_lambda_function" "lambda_servicenow" {
  function_name = "lambda_servicenow"
  handler = "lambda_servicenow.handler"
  role = "${aws_iam_role.lambda_servicenow.arn}"
  runtime = "python3.6"

  filename = "${data.archive_file.lambda_servicenow.output_path}"
  source_code_hash = "${data.archive_file.lambda_servicenow.output_base64sha256}"

  timeout = 30
  memory_size = 128
}

