provider "aws" {
  region = "us-east-1"
}

#Step 1
# resource "aws_instance" "state" {
#   ami = "unknown"
#   instance_type = "unknown"
 
# }

#Execute state import to pull the details of below 
#terraform init 
#terraform import aws_instance.state i-0c614dee691cbbf37


resource "aws_instance" "state" {
  ami = "ami-085ad6ae776d8f09c"
  instance_type = "unknown"
 
}
