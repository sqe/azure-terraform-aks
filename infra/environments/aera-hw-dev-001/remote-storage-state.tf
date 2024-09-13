terraform {
  backend "azurerm" {
    resource_group_name = "aera-hw-dev-002-state"
    storage_account_name = "aerahwdev002state"
    container_name = "aera-hw-dev-002-state"
    key = "terraform.tfstate"
  }
}
resource "azurerm_resource_group" "tfstate" {
  name     = "${var.environment}-state"
  location = var.location[0]
}

resource "azurerm_storage_account" "tfstate" {
  name                     = replace("${var.environment}state","-","")
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "${var.environment}-state"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}