resource "aws_instance" "this" {
  ami = data.aws_ami.this.id
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0031
    }
  }
  instance_type = "t2.medium"
  tags = {
    Name = "test-spot"
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

