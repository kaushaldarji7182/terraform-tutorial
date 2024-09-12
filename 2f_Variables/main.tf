#not complete

provider "aws" {
  region = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}

#Environment variables in terraform 
#export TF_VAR_name=Vilas new instance
#https://developer.hashicorp.com/terraform/cli/config/environment-variables 
variable "name" {
 description = "This is a variable of type string"
 type        = string
 default     = "Vilas Instance"
}



#string_heredoc_type
variable "myuserdata" {
 description = "This is a variable of type string"
 type        = string
 default     = <<EOF
#!/bin/bash
echo "testing heredock type string" > /etc/motd
EOF
}


variable "instance_count" {
 description = "This is a variable of type number"
 type        = number
 default     = 1
}


variable "boolean_type" {
 description = "This is a variable of type bool"
 type        = bool
 default     = true
}


variable "tuple_type" {
 description = "This is a variable of type tuple"
 type        = tuple([string, number, bool])
 default     = ["item1", 42, true]
}


variable "set_example" {
 description = "This is a variable of type set"
 type        = set(string)
 default     = ["item1", "item2", "item3"]
}


variable "map_of_objects" {
  description = "This is a variable of type Map of objects"
  type = map(object({
    name = string,
    cidr = string
  }))
  default = {
    "subnet_a" = {
    name = "Subnet A",
    cidr = "10.10.1.0/24"
    },
  "subnet_b" = {
    name = "Subnet B",
    cidr = "10.10.2.0/24"
    },
  "subnet_c" = {
    name = "Subnet C",
    cidr = "10.10.3.0/24"
    }
  }
}


variable "list_of_objects" {
  description = "This is a variable of type List of objects"
  type = list(object({
    name = string,
    cidr = string
  }))
  default = [
    {
      name = "Subnet A",
      cidr = "10.10.1.0/24"
    },
    {
      name = "Subnet B",
      cidr = "10.10.2.0/24"
    },
    {
      name = "Subnet C",
      cidr = "10.10.3.0/24"
    }
  ]
}


# different types of variables 
/*resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI
  instance_type = "t2.micro"          # Replace with your desired instance type
  key_name      = "vilasohio"         # Replace with your key pair name
  count 		= var.instance_count

  user_data = var.myuserdata
  tags = {
    Name = var.name
  }
  
}
*/
#------------------------- list example 

variable "ami_ids" {
  type        = list(string)
  default     = ["ami-09efc42336106d2f2", "ami-085f9c64a9b75eed5"]
  description = "List of AMI IDs to use for the instances"
}

resource "aws_instance" "example_instances" {
  count = length(var.ami_ids)

  ami           = var.ami_ids[count.index]
  instance_type = "t2.micro"

  tags = {
    "Name" = "Example Instance ${count.index + 1}"
  }
}
#------------------------- maps example 
variable "tags" {
  type        = map(string)
  default     = {
    "Name" = "Example Instance"
    "Environment" = "prod"
  }
  description = "Tags to apply to the instances"
}

/*resource "aws_instance" "example2" {
  count = 2

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = var.tags
}
*/
#------------------------- list of objects 

variable "instances" {
  type        = list(object({
    name = string
    instance_type = string
  }))
  default     = [
    {
      name = "web-server-1"
      instance_type = "t2.micro"
    },
    {
      name = "web-server-2"
      instance_type = "t3.micro"
    }
  ]
  description = "Instances to create"
}
/*
resource "aws_instance" "example3" {
  count = length(var.instances)

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instances[count.index].instance_type
  tags = {
    "Name" = var.instances[count.index].name
  }
}
*/