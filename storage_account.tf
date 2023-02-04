resource "azurerm_storage_account" "st_storage_account" {
  name                     = "stdemoprivatednsresolver"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "storage_account_private_endpoint" {
  count = var.enable_private_endpoint_storageaccount ? 1 : 0

  name                = "pvt-stdemo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet_spoke_private_endpoints.id

  private_dns_zone_group {
    name                 = "storage-account-private-endpoint-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_storage_account.id]
  }

  private_service_connection {
    name                           = "pvt-stdemo"
    private_connection_resource_id = azurerm_storage_account.st_storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
