terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  #required_version = "> 1.2.0"
  #A
  #Below block should should be step 3 
  backend "s3" {
    bucket = "vilas-tfremotestate-ec2-09-02-2025"
    key = "state"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }

}

/*provider "aws" {
  region  = "us-east-1"
}*/

resource "aws_instance" "app_server" {
  ami           = "ami-085ad6ae776d8f09c"
  instance_type = "t2.nano"
}


#Following should be step 2 
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "vilas-tfremotestate-ec2-09-02-2025" # Replace with a unique bucket name

  # Enable versioning (recommended for state management)
  versioning {
    enabled = true
  }

  # Enable server-side encryption (recommended)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Block public access (important for security)
#   block_public_access {
#     block_public_acls       = true
#     block_public_policy     = true
#     ignore_public_acls      = true
#     restrict_public_buckets = true
#   }

  # Optional: Add lifecycle rules for older state files (recommended)
#   lifecycle_rules {
#     prefix = "path/to/my/environment/" # Optional: Prefix for state files
#     enabled = true
#     expiration {
#       days = 30 # Example: Delete state files after 30 days (adjust as needed)
#     }
#     noncurrent_version_expiration {
#       days = 90 # Example: Delete non-current versions after 90 days (adjust as needed)
#     }
#   }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "dev" # Or your environment
  }
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock" # Choose a name
  hash_key       = "LockID" # The primary key attribute

  attribute {
    name = "LockID"
    type = "S" # String type
  }

  billing_mode = "PAY_PER_REQUEST" # Or PROVISIONED if you have consistent high usage

  # Optional: Add tags
  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "dev" # Or your environment
  }
}

# Output the bucket and table names (useful for configuring Terraform CLI)
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state_bucket.id
  description = "Name of the S3 bucket for Terraform state"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_state_lock.name
  description = "Name of the DynamoDB table for Terraform state locking"
}
