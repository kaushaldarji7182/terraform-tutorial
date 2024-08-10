provider "aws" {
  region = "us-east-1"
}
	

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "mysubnet_a" {
  id = "subnet-017dfa3f4487160c0"
}

data "aws_subnet" "mysubnet_b" {
  id = "subnet-02068492068419c37"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}


resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = "my-db-subnet-group"
  subnet_ids = [data.aws_subnet.mysubnet_a.id,data.aws_subnet.mysubnet_b.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "example" {
  engine                 = "mysql"
  db_name                = "vilasdb"
  identifier             = "vilasdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  username               = var.db-username
  password               = var.db-password
  skip_final_snapshot    = true

  vpc_security_group_ids = [data.aws_security_group.default.id]
  db_subnet_group_name 	 = aws_db_subnet_group.my_db_subnet_group.name

  tags = {
    Name = "vilas-db"
  }
}

variable "db-username" {}

variable "db-password" {}