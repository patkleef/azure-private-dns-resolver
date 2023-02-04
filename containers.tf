resource "azurerm_container_group" "cg_spoke_network-multitool" {
  name                = "ci-network-tool-spoke"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  subnet_ids          = [ azurerm_subnet.subnet_spoke_ci.id ]

  container {
    name   = "network-multitool"
    image  = "wbitt/network-multitool"
    cpu    = "1"
    memory = "0.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}

resource "azurerm_container_group" "cg_hub_dns" {
  count = var.deploy_custom_dns ? 1 : 0

  name                = "ci-network-tool-hub"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  subnet_ids          = [ azurerm_subnet.subnet_hub_containers.id ]

  container {
    name   = "dns-forwarder"
    image  = "ghcr.io/whiteducksoftware/az-dns-forwarder/az-dns-forwarder:latest"
    cpu    = "1"
    memory = "0.5"

    ports {
      port     = 53
      protocol = "UDP"
    }
  }
}