# Provider-1 for EastUS (Default Provider)
provider "azurerm" {
  features {}
}

# Provider-2 for WestUS Region
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false # This will ensure when the Virtual Machine is destroyed, Disk is not deleted, default is true and we can alter it at provider level
    }
  }
  alias = "provider2-westus"

}

resource "azurerm_resource_group" "myrg1" {
  name = "myrg-1"
  location = "West US"
    #<PROVIDER NAME>.<ALIAS NAME>
  provider = azurerm
}

resource "azurerm_resource_group" "myrg2" {
  name = "myrg-2"
  location = "West US"
    #<PROVIDER NAME>.<ALIAS NAME>
  provider = azurerm.provider2-westus
}
