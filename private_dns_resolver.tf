resource "azurerm_private_dns_resolver" "hub_private_dns_resolver" {
  count = var.deploy_private_dns_resolver ? 1 : 0

  name                = "pdr-resolver"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_network_id  = azurerm_virtual_network.vnet_hub.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "hub_private_dns_resolver_inbound" {
  count = var.deploy_private_dns_resolver ? 1 : 0

  name                    = "inbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub_private_dns_resolver[0].id
  location                = azurerm_private_dns_resolver.hub_private_dns_resolver[0].location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id = azurerm_subnet.subnet_private_dns_resolver_inbound.id
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "hub_private_dns_resolver_outbound" {
  count = var.deploy_private_dns_resolver ? 1 : 0

  name                    = "outbound-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.hub_private_dns_resolver[0].id
  location                = azurerm_private_dns_resolver.hub_private_dns_resolver[0].location
  subnet_id               = azurerm_subnet.subnet_private_dns_resolver_outbound.id
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "private_dns_resolver_forwarding_ruleset" {
  count = var.deploy_private_dns_resolver ? 1 : 0

  name                                       = "pdr-resolver-aws-ruleset"
  resource_group_name                        = azurerm_resource_group.rg.name
  location                                   = azurerm_resource_group.rg.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.hub_private_dns_resolver_outbound[0].id]
}

resource "azurerm_private_dns_resolver_forwarding_rule" "private_dns_resolver_forwarding_rule" {
  count = var.deploy_private_dns_resolver ? 1 : 0

  name                      = "pdr-resolver-aws-artifacts-rule"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.private_dns_resolver_forwarding_ruleset[0].id
  domain_name               = "artifacts.backbase.com."
  enabled                   = true

  target_dns_servers {
    ip_address = "8.8.8.8"
    port       = 53
  }
}
