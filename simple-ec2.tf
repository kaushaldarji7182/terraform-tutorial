provider "aws" {
  region                  = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_instance" "web" {
  ami           = "ami-0d406e26e5ad4de53"
  instance_type = "t3.micro"
  key_name      = "vilasohio"

  tags = {
    Name = "Vilas Instance"
  }
}


