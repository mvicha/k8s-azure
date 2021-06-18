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
    storage_account_name  = "tstate28512"
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
