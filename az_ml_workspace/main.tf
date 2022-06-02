# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.2"
    }
  }
}

# 2. Define the provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# 3. Get the current client config
data "azurerm_client_config" "current" {}

# 4. Create/Import a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}