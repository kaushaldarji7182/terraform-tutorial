provider "aws" {
  region                  = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  #owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name		= "vilasnv2"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./vilasnv2.pem")
      host        = self.public_ip
      timeout     = "1m"
    }


  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y && sudo apt install nginx -y "
    ]
  }
}