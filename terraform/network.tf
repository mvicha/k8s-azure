# Create virtual network
resource "azurerm_virtual_network" "vn_k8s" {
  name                = "vn_k8s"
  address_space       = [var.virtual_network_cidr]
  location            = azurerm_resource_group.rg_k8s.location
  resource_group_name = azurerm_resource_group.rg_k8s.name

  tags = {
    environment = "K8s"
  }
}


# Create subnet
resource "azurerm_subnet" "sn_k8s_private" {
  name                 = "sn_k8s_private"
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  virtual_network_name = azurerm_virtual_network.vn_k8s.name
  address_prefixes     = [var.subnet_cidr_private]
}


# Create public IPs
resource "azurerm_public_ip" "pi_k8s" {
  name                = "pi_k8s"
  location            = azurerm_resource_group.rg_k8s.location
  resource_group_name = azurerm_resource_group.rg_k8s.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "ghostmvilla"

  tags = {
    environment = "K8s"
  }
}


# Save Public IP into data for output
data "azurerm_public_ip" "pi_k8s" {
  name                = "${azurerm_public_ip.pi_k8s.name}"
  resource_group_name = "${azurerm_resource_group.rg_k8s.name}"
  depends_on          = [azurerm_virtual_machine.vm_k8s_master]
}


# Create K8s master private network interface
resource "azurerm_network_interface" "nic_k8s_master" {
  name                 = "nic_k8s_master"
  location             = azurerm_resource_group.rg_k8s.location
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "nic_config_master"
    subnet_id                     = azurerm_subnet.sn_k8s_private.id
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.pi_k8s.id
    private_ip_address            = var.private_lan_master
  }

  tags = {
    environment = "K8s"
    node        = "Master"
  }
}


# Create K8s node01 private network interface
resource "azurerm_network_interface" "nic_k8s_node" {
  for_each = var.workers
  #count                = length(var.workers)

  #name                 = "nic_k8s_node${count.index}"
  name                 = each.key
  location             = azurerm_resource_group.rg_k8s.location
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  enable_ip_forwarding = true

  ip_configuration {
    #name                          = "nic_config_node${count.index}"
    name                          = "nic_config_${each.key}"
    subnet_id                     = azurerm_subnet.sn_k8s_private.id
    private_ip_address_allocation = "Static"
    #private_ip_address            = var.private_lan_node01
    #private_ip_address            = var.private_ip_address_workers[count.index]
    # private_ip_address            = var.workers[count.index].ip
    private_ip_address            = each.value.ip
  }

  tags = {
    environment = "K8s"
    node        = "Worker"
  }
}


# # Create K8s node01 private network interface
# resource "azurerm_network_interface" "nic_k8s_node01" {
#   name                 = "nic_k8s_node01"
#   location             = azurerm_resource_group.rg_k8s.location
#   resource_group_name  = azurerm_resource_group.rg_k8s.name
#   enable_ip_forwarding = true

#   ip_configuration {
#     name                          = "nic_config_node01"
#     subnet_id                     = azurerm_subnet.sn_k8s_private.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = var.private_lan_node01
#   }

#   tags = {
#     environment = "K8s"
#     node        = "Worker"
#   }
# }


# # Create K8s node02 private network interface
# resource "azurerm_network_interface" "nic_k8s_node02" {
#   name                 = "nic_k8s_node02"
#   location             = azurerm_resource_group.rg_k8s.location
#   resource_group_name  = azurerm_resource_group.rg_k8s.name
#   enable_ip_forwarding = true

#   ip_configuration {
#     name                          = "nic_config_node02"
#     subnet_id                     = azurerm_subnet.sn_k8s_private.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = var.private_lan_node02
#   }

#   tags = {
#     environment = "K8s"
#     node        = "Worker"
#   }
# }
