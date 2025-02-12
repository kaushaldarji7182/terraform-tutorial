provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my_vm" {
 ami           = "ami-0c614dee691cbbf37"
 instance_type = "t2.nano"
 
 key_name        = "vilasnv"
 
 provisioner "remote-exec" {
   inline = [
     "touch hello.txt",
     "echo 'Have a great day!' >> hello.txt"
   ]
 }
 
 connection {
   type        = "ssh"
   host        = self.public_ip
   user        = "ec2-user"
   private_key = file("C:\\Users\\vilas\\Downloads\\vilasnv.pem")
   timeout     = "4m"
 }
 
 tags = {
   Name = "Vilas instance"
 }
}