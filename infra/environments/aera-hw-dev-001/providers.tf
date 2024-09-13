terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  use_oidc = true
  features {}
  subscription_id = var.ARM_SUBSCRIPTION_ID
}

# provider "helm" {
#   kubernetes {
#     host                   = data.azurerm_kubernetes_cluster.aera-hw.kube_config.0.host
#     client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aera-hw.kube_config.0.client_certificate)
#     client_key             = base64decode(data.azurerm_kubernetes_cluster.aera-hw.kube_config.0.client_key)
#     cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aera-hw.kube_config.0.cluster_ca_certificate)
#   }
# }

