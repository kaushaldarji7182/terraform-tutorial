#Create user give ec2 full access


provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create IAM User
resource "aws_iam_user" "ec2_full_access_user" {
  name = "ec2_full_access_user"
  path = "/"
}

# Create IAM Policy for EC2 Full Access
resource "aws_iam_policy" "ec2_full_access_policy" {
  name = "ec2_full_access_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach Policy to User
resource "aws_iam_user_policy_attachment" "attach_ec2_full_access" {
  user = aws_iam_user.ec2_full_access_user.name
  policy_arn = aws_iam_policy.ec2_full_access_policy.arn
}