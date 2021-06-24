terraform {
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstate6619"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
    access_key            = "uQF+DG+zzytI/NPuA5mwruhOo1mwo0HlQMkt6OYoEnJsJbGLkvK9y1i+c/DaHZljMF8tAyQghFc44TqtjnvJfw=="
  }
}
