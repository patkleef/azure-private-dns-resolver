resource "azurerm_public_ip" "pip_vpn_gateway" {
  count = var.deploy_vpn_gateway ? 1 : 0

  name                = "pip-vpn-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  count = var.deploy_vpn_gateway ? 1 : 0

  name                = "gat-vpn-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "Standard"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_vpn_gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet_vpn_gateway_hub.id
  }

  vpn_client_configuration {
    address_space = ["10.2.0.0/24"]

    root_certificate {
      name = "VPNROOT"

      public_cert_data = azurerm_key_vault_secret.vpn_root_certificate.value
    }
  }
}