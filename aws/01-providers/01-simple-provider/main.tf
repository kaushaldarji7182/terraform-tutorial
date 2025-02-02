provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-0c614dee691cbbf37" # Change the AMI 
  instance_type = "t2.micro"
}