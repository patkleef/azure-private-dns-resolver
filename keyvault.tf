resource "azurerm_key_vault" "kv_infra" {
  name = "kv-infra-9372"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
  enabled_for_deployment = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    certificate_permissions = [ "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update" ]
    key_permissions = [ "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey" ]
    secret_permissions = [ "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set" ]
    storage_permissions = [ "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update" ]
  }
  network_acls {
    default_action = "Allow"
    bypass = "AzureServices"
  }
}

resource "azurerm_key_vault_secret" "vpn_root_certificate" {
  name = "vpn-root-certificate"
  value = filebase64("TF-AZURE-VPN-RootCert.crt")
  key_vault_id = azurerm_key_vault.kv_infra.id
}