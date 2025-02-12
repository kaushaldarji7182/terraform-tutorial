provider "aws" {
  region = "us-east-1"
}


variable "instances" {
  type = map(object({
	ami       	= string
	instance_type = string
  }))
  default = {
	instance1 = { ami = "ami-053b0d53c279acc90", instance_type = "t2.nano" }
	instance2 = { ami = "ami-053b0d53c279acc90", instance_type = "t2.small" }
  }
}

#Example of for_each 
resource "aws_instance" "env0" {
  for_each = var.instances
  ami       	= each.value.ami
  instance_type = each.value.instance_type
}

#Example of for 
output "instance_public_ips" {  
  value = {  
    for instance_id, instance in aws_instance.env0 :  
      instance.id => instance.public_ip  
  }  
}  