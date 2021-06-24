# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg_k8s.name
  }

  byte_length = 8
}


# Create storage account for boot diagnostics
resource "azurerm_storage_account" "sa_k8s" {
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.rg_k8s.name
  location                 = azurerm_resource_group.rg_k8s.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "K8s"
  }
}


# Creamos un disco para utilizar como Persistant Storage de Nfs y MySQL
resource "azurerm_managed_disk" "nfs" {
  count                = length(var.workers) > 0 ? 1 : 0

  name                 = "${azurerm_virtual_machine.vm_k8s_node["Node01"].name}-data"
  location             = azurerm_resource_group.rg_k8s.location
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}


# Asociamos el disco de Persistant Storage a Node01
resource "azurerm_virtual_machine_data_disk_attachment" "nfs" {
  count              = length(var.workers) > 0 ? 1 : 0

  managed_disk_id    = azurerm_managed_disk.nfs.0.id
  virtual_machine_id = azurerm_virtual_machine.vm_k8s_node["Node01"].id
  lun                = "10"
  caching            = "ReadWrite"
}
