resource "aws_cloudtrail" "upload" {
  name                          = "${var.cloudtrailname}"
  s3_bucket_name                = "${aws_s3_bucket.createbucket.id}"
  s3_key_prefix                 = "prefix"
  sns_topic_name                =  "arn:aws:sns:${var.region}:${var.account}:${var.snstopicname}"
  include_global_service_events = false
}
