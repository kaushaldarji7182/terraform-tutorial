terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" 
    }
  }
}

# Define a map of regions to AMI IDs
variable "region_ami_map" {
  type = map(string)
  description = "Map of regions to their corresponding AMI IDs"

  default = {
    "us-east-1" = "ami-0c9483720cff7214c"
    "us-west-2" = "ami-0d5d9aecb0d023789"
    "eu-west-1" = "ami-0e25bfe28b07d24f5" 
  }
}

# Create instances in each region
resource "aws_instance" "example" {
  for_each = var.region_ami_map

  ami           = each.value
  instance_type = "t2.micro" 
  provider      = aws.lookup(var.region_ami_map, each.key)

  tags = {
    Name = "instance-${each.key}" 
  }
}

# Define AWS Providers for each region
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}