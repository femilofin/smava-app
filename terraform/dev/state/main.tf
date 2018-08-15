resource "aws_s3_bucket" "state" {
  bucket = "${var.project}-state-${var.environment}"
  acl    = "private"
}
