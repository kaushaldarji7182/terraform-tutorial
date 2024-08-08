provider "aws" {
  region = "eu-west-1"
}
	

data "aws_vpc" "default" {
  default = true
}

#data "aws_subnet_ids" "all" {
#  vpc_id = "${data.aws_vpc.default.id}"
#}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
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
  vpc_security_group_ids = [data.aws_security_group.default.id]
  skip_final_snapshot    = true

  tags = {
    Name = "vilas-db"
  }
}

variable "db-username" {}

variable "db-password" {}