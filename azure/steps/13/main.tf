#Creating multiple instances of vm using count


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
/*  
Step 1
Removed random section  
	random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
*/	
	
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}
/*
Step 2
Remove below block
# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  numeric = false   
}
*/

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
  count =2 	#Step 3 - Added because we need different nic for different vm's
  name                = "vmnic-${count.index}"	#Step 4 name should be unique
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.mypublicip.id 
	public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index)
	#Step 5. change above syntax using splat function
	#The * above is splat function: indiates all, element is to pick a value from the same.
  }
}

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  count = 2	#Step 6. Need multiple public ip
  # Add Explicit Dependency to have this resource created only after Virtual Network and Subnet Resources are created. 
  depends_on = [
    azurerm_virtual_network.myvnet,
    azurerm_subnet.mysubnet
  ]
  name                = "mypublicip-${count.index}"	#Step 7
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  #domain_name_label = "app1-vm-${random_string.myrandom.id}"
  domain_name_label = "app1-vm-${count.index}" 
  #Step 8 above change
  tags = {
    environment = "Dev"
  }
}


# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  count = 2	#Step 9 
  name                = "mylinuxvm-${count.index}"	#Step 10. This should be unique
  computer_name       = "devlinux-${count.index}" # Hostname of the VM Step 11. should be unique
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  #Step 12
  #network_interface_ids = [azurerm_network_interface.myvmnic.id]
  network_interface_ids = [ element(azurerm_network_interface.myvmnic[*].id, count.index)]  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${count.index}"	#Step 12
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
#  source_image_reference {
#    publisher = "RedHat"
#    offer     = "RHEL"
#    sku       = "83-gen2"
#    version   = "latest"
#  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  custom_data = filebase64("./app1-cloud-init.txt")
}