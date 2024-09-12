provider "aws" {
  region = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_iam_group" "administrators" {
  name = "Administrators"
  path = "/"
}

resource "aws_iam_user" "spacelift_user" {
 name = "spacelift-user"
}

resource "aws_iam_user_login_profile" "spacelift_user_login_profile" {
 user    = aws_iam_user.spacelift_user.name
}

output "password" {
 value = aws_iam_user_login_profile.spacelift_user_login_profile.password
}

#Different ways to create policy 
#Type 1  - directly attaching a policy to user 
resource "aws_iam_user_policy" "s3_list_only_policy" {
 name = "S3ListOnlyPolicy"
 user = aws_iam_user.spacelift_user.name

 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [{
   "Effect": "Allow",
   "Action": [
     "s3:ListAllMyBuckets"
   ],
   "Resource": "*"
 }]
}
 EOF
}

#Type 2
resource "aws_iam_policy" "s3_read_only_policy" {
 name = "S3ReadOnlyPolicy"

 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [{
     Effect = "Allow"
     Action = [
       "s3:ListBucket",
       "s3:GetObject"
     ]
     Resource = "*"
   }]
 })
}

resource "aws_iam_user_policy_attachment" "spacelift_user_attach_s3_read_only_policy" {
 user       = aws_iam_user.spacelift_user.name
 policy_arn = aws_iam_policy.s3_read_only_policy.arn
}




#Type 3
data "aws_iam_policy_document" "s3_write_only_policy_document" {
 statement {
   sid = "1"
   actions = [
     "s3:PutObject",
   ]
   resources = ["*"]
 }
}

resource "aws_iam_policy" "s3_write_only_policy" {
 name   = "S3WriteOnlyPolicy"
 policy = data.aws_iam_policy_document.s3_write_only_policy_document.json
}


resource "aws_iam_user_policy_attachment" "spacelift_user_attach_s3_write_only_policy" {
 user       = aws_iam_user.spacelift_user.name
 policy_arn = aws_iam_policy.s3_write_only_policy.arn
}


#Type 4 resource specific policy 
resource "aws_s3_bucket" "user_access_logs1" {
 bucket = "user-access-logs1"
}

data "aws_iam_policy_document" "allow_access_from_uat_account_policy_document" {
 statement {
   principals {
     type        = "AWS"
     identifiers = ["123456789012"]
   }

   actions = [
     "s3:GetObject",
     "s3:PutObject",
     "s3:ListBucket",
   ]

   resources = [
     aws_s3_bucket.user_access_logs1.arn,
     "${aws_s3_bucket.user_access_logs1.arn}/*",
   ]
 }
}

resource "aws_s3_bucket_policy" "allow_access_from_uat_account_policy" {
 bucket = aws_s3_bucket.user_access_logs1.id
 policy = data.aws_iam_policy_document.allow_access_from_uat_account_policy_document.json
}

#Type 4 instead to give access to an ec2 instance 
/*
data "aws_iam_policy_document" "allow_access_from_uat_account_policy_document" {
  statement {
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.user_access_logs1.arn,
      "${aws_s3_bucket.user_access_logs1.arn}/*",
    ]
  }
}

resource "aws_iam_role" "my_role" {
  name = "my_role"

  assume_role_policy = data.aws_iam_policy_document.allow_access_from_uat_account_policy_document.json
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  role = aws_iam_role.my_role.name
}

resource "aws_instance" "my_instance" {
  instance_type = "t2.micro"
  ami = "ami-0c55b159cbfafe1f0"
  iam_instance_profile = aws_iam_instance_profile.my_instance_profile.name
}

*/




#Reference: https://spacelift.io/blog/terraform-iam-policy



















/*
data "aws_iam_policy" "administrator_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "administrators" {
  group      = aws_iam_group.administrators.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
}

resource "aws_iam_user" "administrator" {
  name = "Administrator"
}

resource "aws_iam_user_group_membership" "devstream" {
  user   = aws_iam_user.administrator.name
  groups = [aws_iam_group.administrators.name]
}

resource "aws_iam_user_login_profile" "administrator" {
  user                    = aws_iam_user.administrator.name
  password_reset_required = true
}

output "password" {
  value     = aws_iam_user_login_profile.administrator.password
  sensitive = false
}
*/

#more options
#		rfer: https://blog.gitguardian.com/managing-aws-iam-with-terraform/

