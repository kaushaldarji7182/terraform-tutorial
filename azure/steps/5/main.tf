#Start new

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=1.44.0"
      #version = ">= 2.0" # Commented for Dependency Lock File Demo, uncomment and run. Verify the version
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          # Commented for Dependency Lock File Demo
}

resource "azurerm_resource_group" "myrg1" {
  name     = "myrg1"
  location = "East US"
}

resource "random_string" "myrandom" {
  length = 16
  special = false
  upper = false
}

resource "azurerm_storage_account" "mysa" {
  name = "mysa${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.myrg1.name
  location                 = azurerm_resource_group.myrg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
