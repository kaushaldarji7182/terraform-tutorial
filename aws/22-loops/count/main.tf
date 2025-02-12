provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_server" {
  count = 2
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.nano"
}