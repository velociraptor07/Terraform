provider "azurerm" {
  features {}

 # subscription_id = var.subscription_id
}

terraform {
  backend "azurerm" {
    resource_group_name   = "yash-rg"
    storage_account_name  = "veloyash1107"
    container_name        = "yash01" # The container you created
    key                   = "terraform.tfstate" # Name of the state file in the container
  }
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "yash-rg"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "Yash-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "Yash-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine
resource "azurerm_virtual_machine" "example" {
  name                  = "yash-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B1s"  # Set to B1s for the free tier

  storage_os_disk {
    name              = "example-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1234!"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}