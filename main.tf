provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "example" {
  name     = "second-rg"
  location = "East US"
}
