resource "azurerm_kubernetes_cluster" "aera-hw" {
  name = "${var.environment}-cluster"
  location = var.location  
  resource_group_name = "${var.environment}-RG"
  dns_prefix = "${var.environment}"
  default_node_pool {
    name = "default"
    node_count = 1
    vnet_subnet_id = var.network_subnet_id
    vm_size = "Standard_D2_v3"
  }
  sku_tier = "Free"
  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/19"
  }
  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
  service_principal {
    client_id = var.appId
    client_secret = var.clientSecret
  }
  role_based_access_control_enabled = true
  linux_profile {
    admin_username = var.username
    ssh_key {
      key_data = var.ssh_key_data
    }
  }
}
