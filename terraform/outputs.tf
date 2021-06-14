# SSH Variables
output "ssh_admin_user" {
  value = var.admin_user
}

output "ssh_master_connection" {
  value = "ssh -i resources/external.pem ${var.admin_user}@${data.azurerm_public_ip.pi_k8s.ip_address}"
}

output "ssh_node01_connection" {
  value = "ssh -i resources/internal.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i resources/external.pem -W %h:%p -q ${var.admin_user}@${data.azurerm_public_ip.pi_k8s.ip_address}' ${var.admin_user}@${azurerm_network_interface.nic_k8s_node01.private_ip_address}"
}

output "ssh_node02_connection" {
  value = "ssh -i resources/internal.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i resources/external.pem -W %h:%p -q ${var.admin_user}@${data.azurerm_public_ip.pi_k8s.ip_address}' ${var.admin_user}@${azurerm_network_interface.nic_k8s_node02.private_ip_address}"
}


# Networking
output "master_private_address" {
  value = azurerm_network_interface.nic_k8s_master.private_ip_address
}

output "master_public_address" {
  #value = azurerm_public_ip.pi_k8s.ip_address
  value = data.azurerm_public_ip.pi_k8s.ip_address
}

 output "node01_private_address" {
   value = azurerm_network_interface.nic_k8s_node01.private_ip_address
 }

output "node02_private_address" {
  value = azurerm_network_interface.nic_k8s_node02.private_ip_address
}

output "subnet_cidr_private" {
  value = azurerm_subnet.sn_k8s_private.address_prefixes
}

output "virtual_network_cidr" {
  value = azurerm_virtual_network.vn_k8s.address_space
}
