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
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg_k8s.name
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "K8s"
  }
}

resource "azurerm_managed_disk" "nfs" {
  # Merge NFS with MASTER
  #name                 = "${azurerm_virtual_machine.vm_nfs.name}-data"
  name                 = "${azurerm_virtual_machine.vm_k8s_master.name}-data"
  location             = azurerm_resource_group.rg_k8s.location
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "nfs" {
  managed_disk_id    = azurerm_managed_disk.nfs.id
  #virtual_machine_id = azurerm_virtual_machine.vm_nfs.id
  # Merge NFS with MASTER
  virtual_machine_id = azurerm_virtual_machine.vm_k8s_master.id
  lun                = "10"
  caching            = "ReadWrite"
}
