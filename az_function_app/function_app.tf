resource "azurerm_service_plan" "servicePlan" {
  name                = "ASP-${var.name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_storage_account" "appStorageAccount" {
  name                     = "${var.name}${var.environment}sa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "Storage"
}

resource "azurerm_storage_container" "blobContainer" {
  name                  = each.value
  storage_account_name  = azurerm_storage_account.appStorageAccount.name
  container_access_type = "private"
  for_each              = toset(var.containers)
}

resource "azurerm_application_insights" "applicationInsights" {
  name                = "appi-${var.name}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  sampling_percentage = 0
}

resource "azurerm_linux_function_app" "functionApp" {
  name                = "func-${var.name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name = azurerm_storage_account.appStorageAccount.name
  service_plan_id      = azurerm_service_plan.servicePlan.id

  site_config {
    application_insights_key               = azurerm_application_insights.applicationInsights.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.applicationInsights.connection_string
  }
}
