# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}

# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags = {
    "Name" = "VNET-1"
    "Environment" = "Dev1"
  }

  # Lifecycle Changes
  lifecycle {
    ignore_changes = [ tags, ]
  }

}
#Make changes to the tags outside terraform. Execute plan and see the details.
#Without ignore_changes, if you add a tag outside and apply, it will delete
#With ignore_changes, if you add a tag outside and apply, it will sync it in states files