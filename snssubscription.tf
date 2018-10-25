resource "aws_sns_topic_subscription" "sqs" {
  topic_arn = "arn:aws:sns:${var.region}:${var.account}:${var.snstopicname}"
  protocol  = "sqs"
  endpoint  = "arn:aws:sqs:${var.region}:${var.account}:${var.sqsname}"
}

