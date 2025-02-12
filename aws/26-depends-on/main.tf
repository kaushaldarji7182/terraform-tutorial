provider "aws" {
  region = "us-east-1"
}

#Step 1
resource "aws_instance" "my_vm_step1" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.nano"
 
    tags = {
        Name = "Vilas terraform step1"
    }

    depends_on = [ aws_instance.my_vm_step2 ]
}


resource "aws_instance" "my_vm_step2" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.nano"
 
    tags = {
      Name = "Vilas terraform step 2"
    }
}
