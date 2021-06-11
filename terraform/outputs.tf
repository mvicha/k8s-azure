#output "tls_external_private_key" {
#  value     = tls_private_key.external_ssh.private_key_pem
#  sensitive = true
#}

#output "tls_internal_private_key" {
#  value     = tls_private_key.internal_ssh.private_key_pem
#  sensitive = true
#}

output "master_public_address" {
  #value = azurerm_public_ip.pi_k8s.ip_address
  value = data.azurerm_public_ip.pi_k8s.ip_address
}

output "master_private_address" {
  value = azurerm_network_interface.nic_k8s_master.private_ip_address
}

output "node01_private_address" {
  value = azurerm_network_interface.nic_k8s_node01.private_ip_address
}

output "node02_private_address" {
  value = azurerm_network_interface.nic_k8s_node02.private_ip_address
}

# Merge NFS with MASTER
#output "nfs_private_address" {
#  value = azurerm_network_interface.nic_nfs.private_ip_address
#}

output "ssh_connection" {
  value = "ssh -i resources/external.pem ${var.admin_user}@${data.azurerm_public_ip.pi_k8s.ip_address}"
}
