#Creating multiple instances of vm using for each and also for each chaining


#mkdir vm
#cd vm/
#mkdir ssh-keys
#cd ssh-keys

# Create SSH Key
/*
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f terraform-azure.pem 
*/
#Important Note: Don't give a password. If you give password during generation, everytime you #login to VM, need to provide passphrase.

# List Files
#ls -lrt .

# Files Generated after above command 
#Public Key: 
#	mv terraform-azure.pem.pub terraform-azure.pub
#Private Key: 
#	terraform-azure.pem

# Permissions for Pem file
#chmod 400 terraform-azure.pem
#cd ..

# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}

# Random String Resource
resource "random_string" "myrandom" {
  for_each = var.environment
  length = 6
  upper = false 
  special = false
  number = false   
}




# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = var.environment
  name = "${var.business_unit}-${each.key}-${var.resoure_group_name}"
  location = var.resoure_group_location
}


# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  for_each = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
}

# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  for_each = var.environment
  #name                 = "mysubnet-1"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mysubnet"
  resource_group_name  = azurerm_resource_group.myrg[each.key].name
  virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  for_each = var.environment
  #name                = "mypublicip-1"
  name = "${var.business_unit}-${each.key}-mypublicip"  
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  allocation_method   = "Static"
  #domain_name_label = "app1-vm-${random_string.myrandom[each.key].id}"
  domain_name_label = "app1-vm-${each.key}-${random_string.myrandom[each.key].id}"
  tags = {
    environment = each.key
  }
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  for_each = var.environment
  #name                = "vmnic"
  name = "${var.business_unit}-${each.key}-${var.virtual_network_name}-myvmnic"    
  location            = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id 
  }
}

# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  for_each = var.environment
  name                = "mylinuxvm-${each.key}"
  computer_name       = "${var.business_unit}-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb = 20
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("./app1-cloud-init.txt")
}


