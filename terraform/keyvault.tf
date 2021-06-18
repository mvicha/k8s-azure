resource "azurerm_key_vault" "keyvault_k8s" {
  name                       = "keyvaultk8s"
  location                   = azurerm_resource_group.rg_k8s.location
  resource_group_name        = azurerm_resource_group.rg_k8s.name

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"

  soft_delete_retention_days = 7
}

resource "azurerm_key_vault_access_policy" "keyvault_k8s_ro" {
  key_vault_id = azurerm_key_vault.keyvault_k8s.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_virtual_machine.vm_k8s_master.identity.0.principal_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions = [
    "get",
    "list"
  ]

  secret_permissions = [
    "get",
    "list",
  ]

  certificate_permissions = [
    "get",
    "getissuers",
    "list",
    "listissuers"
  ]

  storage_permissions = [
    "get",
    "getsas",
    "list",
    "listsas"
  ]
}

resource "azurerm_key_vault_access_policy" "keyvault_k8s_rw" {
  key_vault_id = azurerm_key_vault.keyvault_k8s.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]

  certificate_permissions = [
    "create",
    "delete",
    "deleteissuers",
    "get",
    "getissuers",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "recover",
    "setissuers",
    "update",
    "backup",
    "restore"
  ]

  storage_permissions = [
    "backup",
    "delete",
    "deletesas",
    "get",
    "getsas",
    "list",
    "listsas",
    "purge",
    "recover",
    "regeneratekey",
    "restore",
    "set",
    "setsas",
    "update"
  ]
}

resource "azurerm_key_vault_secret" "mysql_admin_password" {
  name         = "mysql-admin-password"
  value        = random_string.mysql_admin_password.result
  key_vault_id = azurerm_key_vault.keyvault_k8s.id

  depends_on   = [
    azurerm_key_vault.keyvault_k8s,
    azurerm_key_vault_access_policy.keyvault_k8s_ro,
    azurerm_key_vault_access_policy.keyvault_k8s_rw
  ]
}

resource "azurerm_key_vault_secret" "mysql_ghost_database" {
  name         = "mysql-ghost-database"
  value        = var.mysql_ghost_database
  key_vault_id = azurerm_key_vault.keyvault_k8s.id

  depends_on   = [
    azurerm_key_vault.keyvault_k8s,
    azurerm_key_vault_access_policy.keyvault_k8s_ro,
    azurerm_key_vault_access_policy.keyvault_k8s_rw
  ]
}

resource "azurerm_key_vault_secret" "mysql_ghost_username" {
  name         = "mysql-ghost-username"
  value        = var.mysql_ghost_username
  key_vault_id = azurerm_key_vault.keyvault_k8s.id

  depends_on   = [
    azurerm_key_vault.keyvault_k8s,
    azurerm_key_vault_access_policy.keyvault_k8s_ro,
    azurerm_key_vault_access_policy.keyvault_k8s_rw
  ]
}

resource "azurerm_key_vault_secret" "mysql_ghost_password" {
  name         = "mysql-ghost-password"
  value        = random_string.mysql_ghost_password.result
  key_vault_id = azurerm_key_vault.keyvault_k8s.id

  depends_on   = [
    azurerm_key_vault.keyvault_k8s,
    azurerm_key_vault_access_policy.keyvault_k8s_ro,
    azurerm_key_vault_access_policy.keyvault_k8s_rw
  ]
}
