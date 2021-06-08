# Configure the Microsoft Azure Provider
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you're using version 1.x, the "features" block is not allowed.
  features {}
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg_k8s" {
  name     = "RG_Kubernetes"
  location = "eastus"

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

