
data "aws_s3_bucket" "existing_bucket" {
  bucket = "us-east-1-vilas-bkt"
}


provider "aws" {
 region = "us-east-1"
}


output "bucket_id" {
  value = data.aws_s3_bucket.existing_bucket.id
}

output "bucket_arn" {
  value = data.aws_s3_bucket.existing_bucket.arn
}

output "bucket_region" {
  value = data.aws_s3_bucket.existing_bucket.region
}

output "bucket_domain_name" {
  value = data.aws_s3_bucket.existing_bucket.bucket_domain_name
}



# data "aws_secretsmanager_secret" "mydb_secret" {
#   arn = "arn:aws:secretsmanager:eu-central-1:532199187081:secret:pg_db-dKuRrd"
# }

# data "aws_secretsmanager_secret_version" "mydb_secret_version" {
#   secret_id = data.aws_secretsmanager_secret.mydb_secret.id
# }

