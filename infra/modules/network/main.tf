resource "azurerm_virtual_network" "aera-hw" {
  name                = "aera-hw"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = "${var.environment}-RG"

  tags = {
    env = var.environment
  }
}

resource "azurerm_subnet" "subnetOne" {
  name                 = "${var.environment}-subnetOne"
  address_prefixes     = ["10.0.0.0/19"]
  resource_group_name  = "${var.environment}-RG"
  virtual_network_name = azurerm_virtual_network.aera-hw.name
}

resource "azurerm_subnet" "dbSubnet" {
  name                 = "${var.environment}-db-subnet"
  address_prefixes     = ["10.0.32.0/19"]
  resource_group_name  ="${var.environment}-RG"
  virtual_network_name = azurerm_virtual_network.aera-hw.name
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }  
}