provider "aws" {
  alias = "my-us-east-1"
  region = "us-east-1"

}

provider "aws" {
  alias = "my-us-east-2"
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.micro"
  provider = aws.my-us-east-1
}

resource "aws_instance" "example2" {
  ami = "ami-018875e7376831abe"
  instance_type = "t2.micro"
  provider = aws.my-us-east-2
}