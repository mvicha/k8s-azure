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

# Data block to reference Azure's client config
data "azurerm_client_config" "current" {}

# Data block to reference Azure's current subscription
data "azurerm_subscription" "current" {}

# Data block for setting Contributor policies
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

# Data block for setting Owner policies
data "azurerm_role_definition" "owner" {
  name = "Owner"
}

