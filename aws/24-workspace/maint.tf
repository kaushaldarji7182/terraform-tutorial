provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_vm" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.nano"
 
    tags = {
    Name = "Vilas terraform"
    }
}