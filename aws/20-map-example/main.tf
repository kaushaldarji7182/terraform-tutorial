#Preferably do a destroy for every apply. Because Terraform doesn't delete old instances properly as you move around with provider.


provider "aws" {
 region = var.region
}

resource "aws_instance" "myinstance" {
 ami = var.ami_mapping[var.region]
 instance_type = "t2.micro"
}

variable "ami_mapping" {
 type = map
 default = {
  "us-east-1" = "ami-085ad6ae776d8f09c"
  "us-east-2" = "ami-088b41ffb0933423f"
 } 
}

variable region {}

output "ami_name" {
 value = aws_instance.myinstance.ami
}