provider "aws" {
  region = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}


data "aws_vpc" "GetVPC" {
/*filter {
    name   = "tag:Name"
    values = ["DefaultVPC"]
          }*/
	id = "vpc-0769329d39592404f"	  
}
data "aws_subnet" "GetPublicSubnet" {
/*filter {
    name   = "tag:Name"
    values = ["DefaultSubnet2a"]
          }*/
		  
	id = "subnet-0feb99d8ca3f92085"	  
}


resource "aws_network_acl" "aws_nacl" {
  vpc_id = data.aws_vpc.GetVPC.id
  subnet_ids = [ data.aws_subnet.GetPublicSubnet.id ]
# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    #cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block 
	cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    #cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    cidr_block = "0.0.0.0/0"
	from_port  = 80
    to_port    = 80
  }

  # allow ingress ephemeral ports 
/*  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 1024
    to_port    = 65535
  }*/

  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 22 
    to_port    = 22
  }

  # allow egress port 80 
/*  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 80  
    to_port    = 80 
  }*/

  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = data.aws_subnet.GetPublicSubnet.cidr_block
    from_port  = 1024
    to_port    = 65535
  }
tags = {
    Name = "Custom_NACL"
}
}

/*

NACL open connection to destination ports 
There is a difference between source port and destination port 

Each client uses a different ephemeral port in source port while making a connection 
Amazon linux uses 	32768 - 61000
ELB 				1024 - 65535
windows server 2003	1025 - 	5000
windows server 2008	49152 - 65535
NAT gateway 		1024 - 65535
Lambda				1024 - 65535

open the appropriate outgoing port 





resource "aws_security_group" "ec2_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = data.aws_vpc.GetVPC.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terraform-security-group"
  }
}



output "NACL" {
  value       = aws_network_acl.aws_nacl.id
  description = "A reference to the created NACL"
}
output "SID" {
  value       = aws_security_group.ec2_sg.id
  description = "A reference to the created NACL Inbound Rule"
}
*/