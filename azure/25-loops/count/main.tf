variable "storage_account_names" {
  type    = list(string)
  default = ["vilassa001", "vilassa002", "vilassa003"]
}

resource "azurerm_resource_group" "example" {
  name     = "storage-rg"
  location = "UK South"
}

resource "azurerm_storage_account" "my_storage" {
  count                    = length(var.storage_account_names)
  name                     = var.storage_account_names[count.index]
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
