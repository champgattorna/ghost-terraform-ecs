#          ███████ ███████ ████████ ██    ██ ██████            
#          ██      ██         ██    ██    ██ ██   ██           
#█████     ███████ █████      ██    ██    ██ ██████      █████ 
#               ██ ██         ██    ██    ██ ██                
#          ███████ ███████    ██     ██████  ██                
                                                              
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                                                 

# Create S3 Bucket for Terraform State
resource "aws_s3_bucket" "ghost_terraform_state" {
  bucket = "${var.name}-terraform-bucket"

  tags = {
    Name = "${var.name}-terraform-bucket"
  }
}

# Configure Bucket Versioning
resource "aws_s3_bucket_versioning" "ghost_bucket_versioning" {
  bucket = aws_s3_bucket.ghost_terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Configure Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "ghost_sse" {
  bucket = aws_s3_bucket.ghost_terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "ghost_terraform_state_lock" {
  name         = "${var.name}-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.name}-terraform-state-lock"
  }
}
