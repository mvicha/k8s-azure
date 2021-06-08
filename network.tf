# Create virtual network
resource "azurerm_virtual_network" "vn_k8s" {
  name                = "vn_k8s"
  address_space       = ["192.168.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg_k8s.name

  tags = {
    environment = "K8s"
  }
}

# Create subnet
resource "azurerm_subnet" "sn_k8s_public" {
  name                 = "sn_k8s_public"
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  virtual_network_name = azurerm_virtual_network.vn_k8s.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource "azurerm_subnet" "sn_k8s_private" {
  name                 = "sn_k8s_private"
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  virtual_network_name = azurerm_virtual_network.vn_k8s.name
  address_prefixes     = ["192.168.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "pi_k8s" {
  name                = "pi_k8s"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg_k8s.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "K8s"
  }
}

# Create K8s master public network interface
resource "azurerm_network_interface" "nic_k8s_external" {
  name                = "nic_k8s_external"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg_k8s.name

  ip_configuration {
    name                          = "nic_config_external"
    subnet_id                     = azurerm_subnet.sn_k8s_public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.0.100"
    public_ip_address_id          = azurerm_public_ip.pi_k8s.id
  }

  tags = {
    environment = "K8s"
  }
}

# Create K8s master private network interface
resource "azurerm_network_interface" "nic_k8s_master" {
  name                = "nic_k8s_master"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg_k8s.name

  ip_configuration {
    name                          = "nic_config_master"
    subnet_id                     = azurerm_subnet.sn_k8s_private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.100"
  }

  tags = {
    environment = "K8s"
    node        = "Master"
  }
}

# Create K8s node01 private network interface
resource "azurerm_network_interface" "nic_k8s_node01" {
  name                = "nic_k8s_node01"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg_k8s.name

  ip_configuration {
    name                          = "nic_config_node01"
    subnet_id                     = azurerm_subnet.sn_k8s_private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.101"
  }

  tags = {
    environment = "K8s"
    node        = "Worker"
  }
}

# Create K8s node02 private network interface
resource "azurerm_network_interface" "nic_k8s_node02" {
  name                = "nic_k8s_node02"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg_k8s.name

  ip_configuration {
    name                          = "nic_config_node02"
    subnet_id                     = azurerm_subnet.sn_k8s_private.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.1.102"
  }

  tags = {
    environment = "K8s"
    node        = "Worker"
  }
}

