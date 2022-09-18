terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = "1.44.0"
      version = ">= 2.0" # Commented for Dependency Lock File Demo, uncomment and run. Verify the version
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
# features {}          # Commented for Dependency Lock File Demo
}
