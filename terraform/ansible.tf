resource "null_resource" "ansible" {
  provisioner "local-exec" {
    # command    = "echo ansible-playbook -i ../ansible/hosts -e jump_host='${data.azurerm_public_ip.pi_k8s.ip_address}' -e admin_user='${var.ssh_user}' -e subnet_cidr_private='${azurerm_subnet.sn_k8s_private.address_prefixes[0]}' -e private_lan_master='${azurerm_network_interface.nic_k8s_master.private_ip_address}' ../ansible/playbook.yml"

    # command    = "echo ansible-playbook -i ../ansible/hosts -e jump_host='${data.azurerm_public_ip.pi_k8s.ip_address}' -e admin_user='${var.ssh_user}' -e subnet_cidr_private='${azurerm_subnet.sn_k8s_private.address_prefixes[0]}' -e private_lan_master='${azurerm_network_interface.nic_k8s_master.private_ip_address}' -e private_lan_node01='${azurerm_network_interface.nic_k8s_node01.private_ip_address}' ../ansible/playbook.yml"

    # command    = "ansible-playbook -i ../ansible/hosts -e jump_host='${data.azurerm_public_ip.pi_k8s.ip_address}' -e admin_user='${var.ssh_user}' -e subnet_cidr_private='${azurerm_subnet.sn_k8s_private.address_prefixes[0]}' -e private_lan_master='${azurerm_network_interface.nic_k8s_master.private_ip_address}' -e private_lan_node01='${azurerm_network_interface.nic_k8s_node01.private_ip_address}' -e private_lan_node02='${azurerm_network_interface.nic_k8s_node02.private_ip_address}' -e internal_private_key_file='${local.internal_private_key_file}' -e external_private_key_file='${local.external_private_key_file}' ../ansible/playbook.yml"
    command    = "ansible-playbook -i ../ansible/hosts -e jump_host='${data.azurerm_public_ip.pi_k8s.ip_address}' -e admin_user='${var.ssh_user}' -e subnet_cidr_private='${azurerm_subnet.sn_k8s_private.address_prefixes[0]}' -e private_lan_master='${azurerm_network_interface.nic_k8s_master.private_ip_address}' -e private_lan_node01='${var.workers["Node01"].ip}' -e private_lan_node02='${var.workers["Node02"].ip}' -e internal_private_key_file='${local.internal_private_key_file}' -e external_private_key_file='${local.external_private_key_file}' -e ghost_url='${data.azurerm_public_ip.pi_k8s.fqdn}' ../ansible/playbook.yml"
  }

  depends_on = [
    azurerm_virtual_machine.vm_k8s_master,
    azurerm_virtual_machine.vm_k8s_node,
    azurerm_virtual_machine_data_disk_attachment.nfs,
    azurerm_key_vault_secret.mysql_admin_password,
    azurerm_key_vault_secret.mysql_ghost_database,
    azurerm_key_vault_secret.mysql_ghost_username,
    azurerm_key_vault_secret.mysql_ghost_password
  ]

  # depends_on = [
  #   azurerm_virtual_machine.vm_k8s_master,
  #   azurerm_virtual_machine.vm_k8s_node01,
  #   azurerm_virtual_machine.vm_k8s_node02,
  #   azurerm_virtual_machine_data_disk_attachment.nfs,
  #   azurerm_key_vault_secret.mysql_admin_password,
  #   azurerm_key_vault_secret.mysql_ghost_database,
  #   azurerm_key_vault_secret.mysql_ghost_username,
  #   azurerm_key_vault_secret.mysql_ghost_password
  # ]
}
