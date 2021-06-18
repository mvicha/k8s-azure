terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.63.0"
    }
  }
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg_k8s" {
  name     = "RG_Kubernetes"
  location = var.location

  tags = {
    environment = "K8s"
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "owner" {
  name = "Owner"
}

