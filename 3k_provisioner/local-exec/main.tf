provider "aws" {
  region                  = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_instance" "web" {
  ami             = "ami-0182f373e66f89c85"
  instance_type   = "t2.micro"
  key_name        = "vilasnv2"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./vilasnv2.pem")
      host        = self.public_ip
      timeout     = "1m"
    }

  provisioner "local-exec" {
    command = "sudo echo ${self.private_ip} >> private_ips.txt"
  }
}

#this would write the file on the local machine.