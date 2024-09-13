resource "azurerm_resource_group" "aera-hw" {
  name     = "${var.environment}-RG"
  location = var.location[0]
}

module "network" {
  source      = "../../modules/network"
  environment = var.environment
  depends_on  = [azurerm_resource_group.aera-hw]
  location    = var.location[0]
}

module "ssh_key" {
  source = "../../modules/ssh"
  location = var.location[0]
  environment = var.environment
  resource_group_id = azurerm_resource_group.aera-hw.id

    depends_on = [ azurerm_resource_group.aera-hw ]
}
module "aks-cluster" {
  source            = "../../modules/aks"
  network_subnet_id = module.network.network_subnet_id
  environment       = var.environment
  depends_on        = [module.ssh_key, module.network]
  location          = var.location[0]
  ssh_key_data = module.ssh_key.key_data
  appId = var.appId
  clientSecret = var.clientSecret
}

data "azurerm_kubernetes_cluster" "aera-hw" {
  name                = "${var.environment}-cluster"
  resource_group_name = "${var.environment}-RG"

  depends_on = [module.aks-cluster]
}

module "argocd" {
  source      = "../../modules/argocd"
  location    = var.location[0]
  environment = var.environment
  depends_on  = [module.aks-cluster]
}

module "mysql-flexible-server" {
  source               = "../../modules/mysql_flexible_serfver"
  environment          = var.environment
  location             = var.location
  network_db_subnet_id = module.network.network_db_subnet_id
  network_vnet_id      = module.network.vnet_id
  depends_on           = [module.network]

}