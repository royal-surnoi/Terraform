resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name  # The name of the bucket, passed from the root module
  
  tags = var.tags
  
}
