provider "aws" {
  region = "us-east-1"
}

#Step 1
# resource "aws_instance" "my_vm_step1" {
#   ami = "ami-0c614dee691cbbf37"
#   instance_type = "t2.nano"
 
#     tags = {
#     Name = "Vilas terraform"
#     }
# }


resource "aws_instance" "my_vm_step2" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = var.instance_type
 
    tags = {
      Name = "Vilas terraform"
    }
}

variable "instance_type" {
  description = "Instance type t2.micro"
  type        = string
  default     = "t2.medium"
 
  validation {
   condition     = can(regex("^[Tt][2-3].(nano|micro|small)", var.instance_type))
   error_message = "Invalid Instance Type name. You can only choose - t2.nano,t2.micro,t2.small"
 }
}