provider "azurerm" {
  subscription_id = "fa4d5daf-6219-4ac5-8718-a1ff86d3fca7"
  tenant_id       = "899789dc-202f-44b4-8472-a6d40f9eb440"
  features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg_k8s" {
  name     = "RG_Kubernetes"
  location = var.location

  tags = {
    environment = "K8s"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.62.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstate18331"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
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
