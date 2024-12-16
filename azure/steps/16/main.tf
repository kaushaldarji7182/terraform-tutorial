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
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}

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
}

# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  #Step 1. Remove count and add below
  for_each 			  = toset(["vm1", "vm2"])  
  name                = "vmnic-${each.key}"	#Step 2 name should be unique
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
	#Step 3 change below to each.key
	#public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index)
    public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id
  }
}

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  #Step 4 replace count as below
  for_each 	= toset(["vm1", "vm2"])

  # Add Explicit Dependency to have this resource created only after Virtual Network and Subnet Resources are created. 
  depends_on = [
    azurerm_virtual_network.myvnet,
    azurerm_subnet.mysubnet
  ]
  #Step 5. Name changes to each 
  #name               = "mypublicip-${count.index}"	
  name                = "mypublicip-${each.key}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  
  #Step 6. change to each.key
  #domain_name_label = "app1-vm-${count.index}" 
  domain_name_label = "app1-${each.key}"  
  
  tags = {
    environment = "Dev"
  }
}


# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  #Step 7
  #for_each = toset(["vm1", "vm2"])  
  #for_each chaining
  for_each = azurerm_network_interface.myvmnic 

  
  #Step 8 . name and computer name changes to each type
  #name                = "mylinuxvm-${count.index}"	
  #computer_name       = "devlinux-${count.index}" # Hostname of the VM. should be unique
  name                = "mylinuxvm-${each.key}"
  computer_name       = "devlinux-${each.key}" # Hostname of the VM should be unique
  
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  
  #Step 9
  #network_interface_ids = [ element(azurerm_network_interface.myvmnic[*].id, count.index)]  
  network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]
	
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
	#Step 10
    name = "osdisk${each.key}"
    #name = "osdisk${count.index}"	
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("./app1-cloud-init.txt")
}