terraform {
  backend "azurerm" {
    resource_group_name   = "terraform"
    storage_account_name  = "terrastate3498"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

