provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "first-rg"
  location = "East US"
}
