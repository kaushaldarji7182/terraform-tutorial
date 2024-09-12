provider "aws" {
  region                  = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
  # profile                 = "development"
  # private_key_path = "~/vilas.pem"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "myec2vm" {
  ami = "ami-09efc42336106d2f2"
  instance_type = "t2.micro"
  key_name = "vilasohio"
  
  for_each = toset(data.aws_availability_zones.available.names)
  availability_zone = each.key  # You can also use each.value because for list items each.key == each.value
  tags = {
    "Name" = "for_each-Demo-${each.value}"
  }
}