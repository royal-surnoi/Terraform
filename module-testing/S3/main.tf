module "s3_bucket" {
  source = "../../modules/S3" # Correct path to the s3_bucket module

  bucket_name    = var.bucket_name

  tags        = {
    
    "project_name" = var.project_name
    "environment"  = var.environment
  }

}


