# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "myTFVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "westus2"
    resource_group_name = azurerm_resource_group.rg.name
}


# valid for terraform version >= 0.14
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}

#Reading the name from a variable
resource "azurerm_resource_group" "rg" {
  #name     = "myFirstResourceGroup" Reading from variables
  name 		= var.resource_group_name
  location 	= "westeurope"
}


#terraform apply
#terraform apply -var "resource_group_name=myNewResourceGroupName"

#This will delete and recreate the resources.