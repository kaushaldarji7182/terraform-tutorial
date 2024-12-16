#Simple for_each example
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
#Below is a map - key value pair 

  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name = "${each.key}-rg"
  location = each.value
}

/*

In Terraform, the for_each meta-argument allows you to create multiple resources of the same type by iterating over a set of values. It's a powerful tool for creating multiple resources with similar configurations but different names or properties.

Breaking Down the Example

In the provided Terraform configuration, we're using for_each to create multiple Azure Resource Groups. Let's analyze the code step-by-step:

Defining the for_each Expression:

We're defining a map with three key-value pairs:
dc1apps: "eastus"
dc2apps: "eastus2"
dc3apps: "westus"
This map will be used to iterate over and create three resource groups.
Creating Resource Groups:

For each key-value pair in the map, Terraform will create a resource group:
The name attribute will be the key of the pair with "-rg" appended.
The location attribute will be the value of the pair.
Example Output:

After running terraform apply, three resource groups will be created:

dc1apps-rg in the eastus region
dc2apps-rg in the eastus2 region
dc3apps-rg in the westus region
Key Benefits of Using for_each:

Conciseness: It allows you to create multiple resources with similar configurations in a concise and readable manner.
Flexibility: You can use for_each with various data structures, including maps, lists, and sets.
Dynamic Resource Creation: You can dynamically create resources based on external data sources or variables.
By effectively utilizing for_each, you can significantly streamline your Terraform configurations and automate the creation of multiple resources.
*/