# Create K8s Master virtual machine
resource "azurerm_virtual_machine" "vm_k8s_master" {
  name                         = "vm_k8s_master"
  location                     = "eastus"
  resource_group_name          = azurerm_resource_group.rg_k8s.name
  primary_network_interface_id = azurerm_network_interface.nic_k8s_master.id
  network_interface_ids        = [azurerm_network_interface.nic_k8s_master.id]
  vm_size                      = "Standard_A2_v2"

  delete_os_disk_on_termination = true

  storage_os_disk {
    name                 = "K8s_Master_OS"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  os_profile {
    computer_name                   = "Master"
    admin_username                  = var.ssh_user
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.ssh_user}/.ssh/authorized_keys"
      key_data = local.external_public_key_data
    }
    ssh_keys {
      path     = "/home/${var.ssh_user}/.ssh/authorized_keys"
      key_data = local.internal_public_key_data
    }
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    enabled             = true
    storage_uri = azurerm_storage_account.sa_k8s.primary_blob_endpoint
  }

  tags = {
    environment = "K8s"
    node        = "Master"
  }
}

resource "azurerm_virtual_machine" "vm_k8s_node" {
  for_each = var.workers

  name                         = "vm_k8s_${each.key}"
  location                     = "eastus"
  resource_group_name          = azurerm_resource_group.rg_k8s.name
  primary_network_interface_id = azurerm_network_interface.nic_k8s_node[each.key].id
  network_interface_ids        = [azurerm_network_interface.nic_k8s_node[each.key].id]
  vm_size                      = "Standard_A1_v2"

  delete_os_disk_on_termination = true

  storage_os_disk {
    name                 = "K8s_${each.key}_OS"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  os_profile {
    computer_name                   = each.key
    admin_username                  = var.ssh_user
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.ssh_user}/.ssh/authorized_keys"
      key_data = local.internal_public_key_data
    }
  }

  boot_diagnostics {
    enabled             = true
    storage_uri = azurerm_storage_account.sa_k8s.primary_blob_endpoint
  }

  tags = {
    environment = "K8s"
    node        = "Worker"
  }
}
