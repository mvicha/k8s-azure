# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg_k8s_external" {
  name                = "nsg_k8s_external"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg_k8s.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "K8s"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_nsg_external" {
  network_interface_id      = azurerm_network_interface.nic_k8s_external.id
  network_security_group_id = azurerm_network_security_group.nsg_k8s_external.id
}

# Create (and display) an SSH key for connecting from WAN
resource "tls_private_key" "external_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create (and display) an SSH key for connecting from LAN
resource "tls_private_key" "internal_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save external pem to file
resource "local_file" "external_pem" { 
  filename             = "${path.module}/resources/external.pem"
  content              = tls_private_key.external_ssh.private_key_pem
  directory_permission = "0700"
  file_permission      = "0400"
}

# Save internal pem to file
resource "local_file" "internal_pem" { 
  filename             = "${path.module}/resources/internal.pem"
  content              = tls_private_key.internal_ssh.private_key_pem
  directory_permission = "0700"
  file_permission      = "0400"
}

