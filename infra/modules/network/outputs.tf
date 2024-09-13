output "network_subnet_id" {
    value = azurerm_subnet.subnetOne.id 
}

output "vnet_id" {
    value = azurerm_virtual_network.aera-hw.id
}

output "network_db_subnet_id" {
    value = azurerm_subnet.dbSubnet.id
}