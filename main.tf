locals {
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-dns-demo"
  location = "westeurope"
}

