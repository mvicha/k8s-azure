# Create Network Security Group and rule
# Allow port 22 (SSH)
# Allow port 80 (HTTP)
# Allow port 443 (HTTPS)
resource "azurerm_network_security_group" "nsg_k8s_external" {
  name                = "nsg_k8s_external"
  location            = azurerm_resource_group.rg_k8s.location
  resource_group_name = azurerm_resource_group.rg_k8s.name

  security_rule {
    name                       = "SSH"
    description                = "Accept SSH connections only from specific address"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    description                = "Accept HTTP connections from everyone"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    description                = "Accept HTTPS connections from everyone"
    priority                   = 1021
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "K8s"
  }
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_nsg_external" {
  network_interface_id      = azurerm_network_interface.nic_k8s_master.id
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
  count                = length(var.private_key_path) == 0 || length(var.public_key_path) == 0 ? 1 : 0

  filename             = "${path.module}/resources/external.pem"
  content              = tls_private_key.external_ssh.private_key_pem
  directory_permission = "0700"
  file_permission      = "0400"
}


# Save internal pem to file
resource "local_file" "internal_pem" { 
  count                = length(var.private_key_path) == 0 || length(var.public_key_path) == 0 ? 1 : 0

  filename             = "${path.module}/resources/internal.pem"
  content              = tls_private_key.internal_ssh.private_key_pem
  directory_permission = "0700"
  file_permission      = "0400"
}

# Generate a random mysql-admin-password containing 18 characters from which: at least 2 are lower case, 2 are upper case, 2 are numerical and 2 are special characters
resource "random_string" "mysql_admin_password" {
  length           = 18
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "/@-.,_"
}

# Generate a random mysql-ghost-username containing 12 characters from which: at least 2 are lower case, 2 are upper case and 2 are numerical
resource "random_string" "mysql_ghost_username" {
  special     = false
  length      = 8
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
}

# Generate a random mysql-ghost-password containing 18 characters from which: at least 2 are lower case, 2 are upper case, 2 are numerical and 2 are special characters
resource "random_string" "mysql_ghost_password" {
  length           = 18
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "/@-.,_"
}
