provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
    #This is indicative. Don't do this because if this is checked in there can be attacks.
  subscription_id = "your-azure-subscription-id"
  client_id = "your-azure-client-id"
  client_secret = "your-azure-client-secret"
  tenant_id = "your-azure-tenant-id"
}

#In your other Terraform configuration files, you can then use the aws and azurerm providers to create resources in AWS and Azure, respectively,
resource "aws_instance" "example" {
  ami = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
}

resource "azurerm_virtual_machine" "example" {
  name = "example-vm"
  location = "eastus"
  size = "Standard_A1"
}