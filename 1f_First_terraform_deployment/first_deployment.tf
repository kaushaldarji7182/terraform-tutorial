provider "aws" {
#  access_key = "Access Key"
#  secret_key = "Secrey Key"
  shared_credentials_files = ["~/.aws/credentials"]
  region     = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
