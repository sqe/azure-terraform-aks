# Generate random value for the name
resource "random_string" "name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# Generate random value for the login password
resource "random_password" "password" {
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true
}


# Enables you to manage Private DNS zones within Azure DNS
resource "azurerm_private_dns_zone" "default" {
  name                = "${var.environment}.mysql.database.azure.com"
  resource_group_name = "${var.environment}-RG"
}

# Enables you to manage Private DNS zone Virtual Network Links
resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "mysqlfsVnetZone${var.environment}.com"
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  resource_group_name   = "${var.environment}-RG"
  virtual_network_id    = var.network_vnet_id

}

# Manages the MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "primary" {
  location                     = var.location[0]
  name                         = "mysqlfs-${var.environment}"
  resource_group_name          = "${var.environment}-RG"
  administrator_login          = "SuperSecret99"
  administrator_password       = "SuperSecretUser1#"
  backup_retention_days        = 7
  delegated_subnet_id          = var.network_db_subnet_id
  geo_redundant_backup_enabled = false
  private_dns_zone_id          = azurerm_private_dns_zone.default.id
  sku_name                     = "GP_Standard_D2ds_v4"
  version                      = "8.0.21"
  
  zone = "1"
  high_availability {
    mode                      = "SameZone"
  }
  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }
  storage {
    iops    = 360
    size_gb = 20
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}

resource "azurerm_mysql_flexible_server" "replica" {
  count = length(var.location)

  location                     = var.location[count.index]
  name                         = format("mysqlfs-replica-%s-%s", var.environment, var.location[count.index])
  resource_group_name          = "${var.environment}-RG"
  # administrator_login          = random_string.name.result
  # administrator_password       = random_password.password.result
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  # private_dns_zone_id          = azurerm_private_dns_zone.default.id
  sku_name                     = "GP_Standard_D2ds_v4"
  version                      = "8.0.21"
  
  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }
  storage {
    iops    = 360
    size_gb = 20
  }
  create_mode = "Replica"
  source_server_id = azurerm_mysql_flexible_server.primary.id
  depends_on = [azurerm_mysql_flexible_server.primary]

  }
