#This is the top-level block in a Terraform configuration file.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
#~> Terraform will use the latest minor and patch versions of the provider that are compatible with version 4.0.
#This helps ensure compatibility. Allows for automatic updates to newer versions within the same major version.      
    }
  }
}

resource "aws_instance" "example" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.micro"
}