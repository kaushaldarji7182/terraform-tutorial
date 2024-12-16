# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  } 
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "VilasRG"			#change this to resource group you created.
    storage_account_name  = "vilasstorageac"	#change this to storage a/c created by you
    container_name        = "tfstatefiles"
    key                   = "state-commands-demo1.tfstate" #modified key name. tf supports it.
  }   
}

# Provider Block
provider "azurerm" {
 features {}          
}
