#https://spacelift.io/blog/terraform-provisioners

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my_vm" {
 ami = "ami-0c614dee691cbbf37"
 instance_type = "t2.nano"
 
 provisioner "local-exec" {
   command = "echo ${self.private_ip} >> private_ip.txt"
 }
 
 tags = {
   Name = "Vilas terraform"
 }
}

#cat private_ip.txt in your local machine where you executed terraform apply 