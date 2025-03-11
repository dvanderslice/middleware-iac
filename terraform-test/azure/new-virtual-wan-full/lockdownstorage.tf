##Storage Account Network Rules##

resource "azurerm_storage_account_network_rules" "config_storage_rules" {
  storage_account_id = azurerm_storage_account.config_sa.id

  default_action             = "Deny"
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_account_network_rules" "op_storage_rules" {
  storage_account_id = azurerm_storage_account.op_sa.id

  default_action             = "Deny"
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_account_network_rules" "ai_storage_rules" {
  storage_account_id = azurerm_storage_account.ai_sa.id

  default_action             = "Deny"
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_account_network_rules" "cfrn_storage_rules" {
  storage_account_id = azurerm_storage_account.cfrn_sa.id

  default_action             = "Allow"
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_account_network_rules" "hlp_storage_rules" {
  storage_account_id = azurerm_storage_account.hlp_sa.id

  default_action             = "Deny"
  bypass                     = []
}