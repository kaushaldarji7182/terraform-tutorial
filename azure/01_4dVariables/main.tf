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

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-${var.system}"
    location = var.location
    tags      = {
      Environment = var.system
    }
}

variable "system" {
    type = string
    description = "Name of the system or environment"
	default = "vilassystem"
}

variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    default = "westus2"
}