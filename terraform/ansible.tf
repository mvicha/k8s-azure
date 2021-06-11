resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command    = "ansible-playbook -i ../ansible/hosts -e jump_host='${data.azurerm_public_ip.pi_k8s.ip_address}' ../ansible/playbook.yml"
  }

  # Merge NFS with MASTER
  #depends_on = [azurerm_virtual_machine.vm_k8s_master, azurerm_virtual_machine.vm_k8s_node01, azurerm_virtual_machine.vm_k8s_node02, azurerm_virtual_machine.vm_nfs]
  depends_on = [azurerm_virtual_machine.vm_k8s_master, azurerm_virtual_machine.vm_k8s_node01, azurerm_virtual_machine.vm_k8s_node02]
  #depends_on = [azurerm_virtual_machine.vm_k8s_master]
}
