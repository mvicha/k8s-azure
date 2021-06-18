# SSH Variables
output "ssh_admin_user" {
  value = var.ssh_user
}

output "ssh_master_connection" {
  value = "ssh -i ${local.external_private_key_file} ${var.ssh_user}@${data.azurerm_public_ip.pi_k8s.ip_address}"
}

# output "ssh_node01_connection" {
#   value = "ssh -i ${local.internal_private_key_file} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i ${local.external_private_key_file} -W %h:%p -q ${var.ssh_user}@${data.azurerm_public_ip.pi_k8s.ip_address}' ${var.ssh_user}@${azurerm_network_interface.nic_k8s_node[0].private_ip_address}"
# }

# output "ssh_node02_connection" {
#   value = "ssh -i ${local.internal_private_key_file} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i ${local.external_private_key_file} -W %h:%p -q ${var.ssh_user}@${data.azurerm_public_ip.pi_k8s.ip_address}' ${var.ssh_user}@${azurerm_network_interface.nic_k8s_node[1].private_ip_address}"
# }

output "ssh_node01_connection" {
  value = "ssh -i ${local.internal_private_key_file} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i ${local.external_private_key_file} -W %h:%p -q ${var.ssh_user}@${data.azurerm_public_ip.pi_k8s.ip_address}' ${var.ssh_user}@${azurerm_network_interface.nic_k8s_node["Node01"].private_ip_address}"
}

output "ssh_node02_connection" {
  value = "ssh -i ${local.internal_private_key_file} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -i ${local.external_private_key_file} -W %h:%p -q ${var.ssh_user}@${data.azurerm_public_ip.pi_k8s.ip_address}' ${var.ssh_user}@${azurerm_network_interface.nic_k8s_node["Node02"].private_ip_address}"
}


# Networking
output "master_private_address" {
  value = azurerm_network_interface.nic_k8s_master.private_ip_address
}

output "master_public_address" {
  #value = azurerm_public_ip.pi_k8s.ip_address
  value = data.azurerm_public_ip.pi_k8s.ip_address
}

#  output "node01_private_address" {
#    value = azurerm_network_interface.nic_k8s_node[0].private_ip_address
#  }

# output "node02_private_address" {
#   value = azurerm_network_interface.nic_k8s_node[1].private_ip_address
# }

output "node01_private_address" {
   value = azurerm_network_interface.nic_k8s_node["Node01"].private_ip_address
 }

output "node02_private_address" {
  value = azurerm_network_interface.nic_k8s_node["Node02"].private_ip_address
}

output "subnet_cidr_private" {
  value = azurerm_subnet.sn_k8s_private.address_prefixes
}

output "virtual_network_cidr" {
  value = azurerm_virtual_network.vn_k8s.address_space
}

# Ghost URL
output "ghost_http_service_url" {
  #value = "http://${data.azurerm_public_ip.pi_k8s.ip_address}"
  value = "http://${data.azurerm_public_ip.pi_k8s.fqdn}"
}

output "ghost_https_service_url" {
  #value = "http://${data.azurerm_public_ip.pi_k8s.ip_address}"
  value = "https://${data.azurerm_public_ip.pi_k8s.fqdn}"
}

output "WARNING" {
  value = length(var.public_key_path) > 0 && length(var.private_key_path) == 0 ? "Estás pasando un valor para PUBLIC_KEY_PATH pero PRIVATE_KEY_PATH está vacío" : (length(var.private_key_path) > 0 && length(var.public_key_path) == 0 ? "Estás pasando un valor PRIVATE_KEY_PATH pero PUBLIC_KEY_PATH está vacío" : "")
}


# Ansible command line
output "ansible_exec_command" {
  value = "ansible-playbook -i ../ansible/hosts -e jump_host='${data.azurerm_public_ip.pi_k8s.ip_address}' -e admin_user='${var.ssh_user}' -e subnet_cidr_private='${azurerm_subnet.sn_k8s_private.address_prefixes[0]}' -e private_lan_master='${azurerm_network_interface.nic_k8s_master.private_ip_address}' -e private_lan_node01='${var.workers["Node01"].ip}' -e private_lan_node02='${var.workers["Node02"].ip}' -e internal_private_key_file='${local.internal_private_key_file}' -e external_private_key_file='${local.external_private_key_file}' -e ghost_url='${data.azurerm_public_ip.pi_k8s.fqdn}' ../ansible/playbook.yml"
}
