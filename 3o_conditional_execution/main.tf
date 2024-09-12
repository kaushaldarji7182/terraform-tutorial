provider "aws" {
  region                  = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}


variable "create_instance" {
  type        = bool
  default     = false
  description = "Whether to create an EC2 instance (1 for true, 0 for false)"
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

  owners = ["099720109477"] # Canonical
}

# EC2 Instance
resource "aws_instance" "myec2vm" {

  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "vilasohio"
  
  count = var.create_instance ? 1 : 0
  tags = {
    "Name" = "Count-Demo-${count.index}"
  }
}