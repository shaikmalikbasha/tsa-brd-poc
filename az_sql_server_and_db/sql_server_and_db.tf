resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_server_username
  administrator_login_password = var.sql_server_password

  tags = {
    environment = "cos-development-sql-server"
  }

}

resource "azurerm_mssql_database" "sql_database" {
  name                 = var.sql_database_name
  server_id            = azurerm_mssql_server.sql_server.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  max_size_gb          = 2
  sku_name             = "Basic"
  storage_account_type = "Local"

  tags = {
    environment = "cos-development-sql-server-database"
  }

}
