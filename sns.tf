resource "aws_sns_topic" "upload" {
  name = "${var.snstopicname}"
  policy = <<POLICY1
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "AWSCloudTrailSNSPolicy20131101",
        "Effect": "Allow",
        "Principal": {"Service": "cloudtrail.amazonaws.com"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:${var.region}:${var.account}:${var.snstopicname}"
    }]
}
POLICY1
}

