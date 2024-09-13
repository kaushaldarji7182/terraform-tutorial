/*provider "aws" {
  region = "us-west-2"  # Specify your AWS region

}*/
 
resource "aws_quicksight_user" "example" {

  namespace = "default"
  user_name = "example-user"
  email     = "example-user@example.com"
  identity_type = "IAM"
  aws_account_id = "your-aws-account-id"
  role           = "READER"  # Use "ADMIN", "AUTHOR", or "READER" based on your needs
}
 
resource "aws_quicksight_group" "example" {
  namespace = "default"
  group_name = "example-group"
  description = "Example QuickSight group"
  aws_account_id = "your-aws-account-id"

}
 
resource "aws_quicksight_group_membership" "example" {
  group_name = aws_quicksight_group.example.group_name
  namespace  = "default"
  user_name  = aws_quicksight_user.example.user_name
  aws_account_id = "your-aws-account-id"

}
