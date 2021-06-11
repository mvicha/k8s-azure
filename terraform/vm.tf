# Create K8s Master virtual machine
resource "azurerm_virtual_machine" "vm_k8s_master" {
  name                         = "vm_k8s_master"
  location                     = "eastus"
  resource_group_name          = azurerm_resource_group.rg_k8s.name
  primary_network_interface_id = azurerm_network_interface.nic_k8s_external.id
  network_interface_ids        = [azurerm_network_interface.nic_k8s_external.id, azurerm_network_interface.nic_k8s_master.id]
  #vm_size                      = "Standard_DS1_v2"
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
    admin_username                  = var.admin_user
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
      key_data = tls_private_key.external_ssh.public_key_openssh
    }
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

# Create K8s Node01 virtual machine
#resource "azurerm_virtual_machine" "vm_k8s_node01" {
#  name                         = "vm_k8s_node01"
#  location                     = "eastus"
#  resource_group_name          = azurerm_resource_group.rg_k8s.name
#  primary_network_interface_id = azurerm_network_interface.nic_k8s_node01.id
#  network_interface_ids        = [azurerm_network_interface.nic_k8s_node01.id]
#  #vm_size                      = "Standard_DS1_v2"
#  vm_size                      = "Standard_A1_v2"
#
#  delete_os_disk_on_termination = true
#
#  storage_os_disk {
#    name                 = "K8s_Node01_OS"
#    caching              = "ReadWrite"
#    create_option        = "FromImage"
#    managed_disk_type    = "Standard_LRS"
#  }
#
#  storage_image_reference {
#    publisher = "Debian"
#    offer     = "debian-10"
#    sku       = "10"
#    version   = "latest"
#  }
#
#  os_profile {
#    computer_name                   = "Node01"
#    admin_username                  = var.admin_user
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = true
#    ssh_keys {
#      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
#      key_data = tls_private_key.internal_ssh.public_key_openssh
#    }
#  }
#
#  boot_diagnostics {
#    enabled             = true
#    storage_uri = azurerm_storage_account.sa_k8s.primary_blob_endpoint
#  }
#
#  tags = {
#    environment = "K8s"
#    node        = "Worker"
#  }
#}
#
## Create K8s Node02 virtual machine
#resource "azurerm_virtual_machine" "vm_k8s_node02" {
#  name                         = "vm_k8s_node02"
#  location                     = "eastus"
#  resource_group_name          = azurerm_resource_group.rg_k8s.name
#  primary_network_interface_id = azurerm_network_interface.nic_k8s_node02.id
#  network_interface_ids        = [azurerm_network_interface.nic_k8s_node02.id]
#  #vm_size                      = "Standard_DS1_v2"
#  #vm_size                      = "Standard_B2s"
#  vm_size                      = "Standard_A1_v2"
#  
#
#  delete_os_disk_on_termination = true
#
#  storage_os_disk {
#    name                 = "K8s_Node02_OS"
#    caching              = "ReadWrite"
#    create_option        = "FromImage"
#    managed_disk_type    = "Standard_LRS"
#  }
#
#  storage_image_reference {
#    publisher = "Debian"
#    offer     = "debian-10"
#    sku       = "10"
#    version   = "latest"
#  }
#
#  os_profile {
#    computer_name                   = "Node02"
#    admin_username                  = var.admin_user
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = true
#    ssh_keys {
#      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
#      key_data = tls_private_key.internal_ssh.public_key_openssh
#    }
#  }
#
#  boot_diagnostics {
#    enabled             = true
#    storage_uri = azurerm_storage_account.sa_k8s.primary_blob_endpoint
#  }
#
#  tags = {
#    environment = "K8s"
#    node        = "Worker"
#  }
#}

# Merge NFS with Master
## Create NFS virtual machine
#resource "azurerm_virtual_machine" "vm_nfs" {
#  name                         = "vm_nfs"
#  location                     = "eastus"
#  resource_group_name          = azurerm_resource_group.rg_k8s.name
#  primary_network_interface_id = azurerm_network_interface.nic_nfs.id
#  network_interface_ids        = [azurerm_network_interface.nic_nfs.id]
#  #vm_size                      = "Standard_DS1_v2"
#  #vm_size                      = "Standard_B1s"
#  vm_size                      = "Standard_A1_v2"
#
#  delete_os_disk_on_termination = true
#
#  # Comment this out after tests
#  delete_data_disks_on_termination = true
#
#  storage_os_disk {
#    name                 = "K8s_NFS_OS"
#    caching              = "ReadWrite"
#    create_option        = "FromImage"
#    managed_disk_type    = "Standard_LRS"
#  }
#
#  storage_image_reference {
#    publisher = "Debian"
#    offer     = "debian-10"
#    sku       = "10"
#    version   = "latest"
#  }
#
#  os_profile {
#    computer_name                   = "Nfs"
#    admin_username                  = var.admin_user
#  }
#
#  os_profile_linux_config {
#    disable_password_authentication = true
#    ssh_keys {
#      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
#      key_data = tls_private_key.internal_ssh.public_key_openssh
#    }
#  }
#
#  boot_diagnostics {
#    enabled             = true
#    storage_uri = azurerm_storage_account.sa_k8s.primary_blob_endpoint
#  }
#
#  tags = {
#    environment = "K8s"
#    node        = "NFS"
#  }
#}

