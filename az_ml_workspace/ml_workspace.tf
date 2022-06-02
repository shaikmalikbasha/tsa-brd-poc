# Dependent resources for Azure Machine Learning
resource "azurerm_application_insights" "mlAppInsights" {
  name                = "appi-${var.name}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_key_vault" "mlKeyVault" {
  name                     = "kv-${var.name}-${var.environment}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false
}

resource "azurerm_storage_account" "mlStorageAccount" {
  name                     = "st${var.name}${var.environment}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_container_registry" "mlContainerRegistry" {
  name                = "acr${var.name}${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  admin_enabled       = true
}

# Machine Learning workspace
resource "azurerm_machine_learning_workspace" "mlWorkspace" {
  name                    = "cos-mlw-${var.name}-${var.environment}"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  application_insights_id = azurerm_application_insights.mlAppInsights.id
  key_vault_id            = azurerm_key_vault.mlKeyVault.id
  storage_account_id      = azurerm_storage_account.mlStorageAccount.id
  container_registry_id   = azurerm_container_registry.mlContainerRegistry.id

  identity {
    type = "SystemAssigned"
  }
}
