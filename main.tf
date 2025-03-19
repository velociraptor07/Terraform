provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "example" {
  name     = "first-rg"
  location = "East US"
}
