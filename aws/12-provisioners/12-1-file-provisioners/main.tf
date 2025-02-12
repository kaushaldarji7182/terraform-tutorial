
#Not tested - but something similar was done in the class.
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_vm" {
 ami           = "ami-0c614dee691cbbf37"
 instance_type = "t2.nano"
 
 key_name        = "vilasnv"

 provisioner "file" {
   source      = "./letsdotech.txt"
   destination = "/home/ec2-user/letsdotech.txt"
 }
 connection {
   type        = "ssh"
   host        = self.public_ip
   user        = "ec2-user"
   private_key = file("./vilasnv.pem")
   timeout     = "4m"
 }
 
 tags = {
   Name = "Vilas test"
 }
}