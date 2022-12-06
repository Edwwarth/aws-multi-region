resource "aws_s3_bucket" "example_bucket" {
  bucket = "ed-bucket-testing"

  tags = {
    Name = "Example Bucket"
    Terraform = true
    Testing = true
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.example_bucket.id
  acl    = "private"
}

locals {
  s3_origin_id = "example_S3Origin"
}
