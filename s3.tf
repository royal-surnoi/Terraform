# # Create the S3 bucket
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = var.environment != "" ? "fusioniq-project-${var.environment}" : "fusioniq-project"

#   tags = {
#     Name        = "fusioniq-project-${var.environment}"
#     Environment = var.environment
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# # Enable versioning using aws_s3_bucket_versioning
# resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # Define lifecycle rules using aws_s3_bucket_lifecycle_configuration
# resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_lifecycle" {
#   bucket = aws_s3_bucket.terraform_state.id

#   rule {
#     id     = "delete-old-state-versions"
#     status = "Enabled"

#     noncurrent_version_expiration {
#       noncurrent_days = 7
#     }

#     # Optional: If you want to delete the current file after 30 days
#     # Only enable this if you have a backup mechanism
#     expiration {
#       days = 30
#     }
#   }
# }

# # Enable server-side encryption for security
# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
#   bucket = aws_s3_bucket.terraform_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }
