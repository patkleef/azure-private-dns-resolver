resource "azurerm_private_dns_zone" "private_dns_storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_sa_hub_link" {
  name                  = "private-dns-storage-account-hub-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_storage_account.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_sa_spoke_link" {
  name                  = "private-dns-storage-account-spoke-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_storage_account.name
  virtual_network_id    = azurerm_virtual_network.vnet_spoke.id
}
