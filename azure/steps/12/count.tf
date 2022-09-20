# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  count = 3			#added this
  name = "myrg-${count.index}"	#modified this
  location = "East US"
}