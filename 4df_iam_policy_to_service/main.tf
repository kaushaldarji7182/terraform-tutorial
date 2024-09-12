provider "aws" {
region = "us-east-2"
shared_credentials_files = ["~/.aws/credentials"]
}

data "aws_iam_policy_document" "s3writeonly-policy-document" {
  statement {
    sid = "1"
    effect = "Allow"
    
    principals  {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    # resources = ["*"]
  }
}

resource "aws_iam_role" "my-role" {
  name = "rinku-role"
  assume_role_policy = data.aws_iam_policy_document.s3writeonly-policy-document.json
  path = "/system/"
}

resource "aws_iam_role_policy_attachment" "my-role-attachment" {
  role = aws_iam_role.my-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "my-instance-profile" {
  role = aws_iam_role.my-role.name
}

resource "aws_instance" "ec2-instance" {
  ami = "ami-0d406e26e5ad4de53"
  instance_type = "t2.micro"
  key_name = "rinku"
  iam_instance_profile = aws_iam_instance_profile.my-instance-profile.name
  tags = {
    Name = "rinku ec2 instance"
  }
}