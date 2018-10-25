resource "aws_sqs_queue" "upload" {
  name = "${var.sqsname}"
  policy = <<POLICY
         {
           "Version": "2012-10-17",
           "Id": "arn:aws:sqs:${var.region}:${var.account}:${var.sqsname}/SQSDefaultPolicy",
           "Statement": [
             {
               "Sid": "Sid1537540952234",
               "Effect": "Allow",
               "Principal": "*",
               "Action": "SQS:*",
               "Resource": "arn:aws:sqs:${var.region}:${var.account}:${var.sqsname}"
             }
           ]
         }
POLICY
}

