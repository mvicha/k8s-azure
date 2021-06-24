# Esta línea de comandos se ejecutará al terminar de aprovisionar la infraestructura de Azure.
# Recibe los siguientes parámetros para configurar Ansible y así provisionar los servicios de Kubernetes y deployments correspondientes
#   jump_host:
#       Teraform expone el puerto 22 sólo en la dirección IP pública asociada a Master, por lo que para acceder por SSH a los nodos es necesario conectarse por medio de este servidor Master antes de acceder a los Nodos. Así es que se define a Master como jump_host
#   admin_user:
#       En las variables de Terraform hemos configurado el ssh_user que utilizaremos para conectarnos a las máquinas virtuales. Este mismo se le pasa a Ansible como parámetro, ya que puede variar
#   subnet_cidr_private
#       No se aconseja cambiar los parámetros de red, pero esta se envía para poder configurar Nfs para que sólo sirva los archivos a esta subred
#   private_lan_master
#       Dirección IP privada de Master
#   private_lan_node01
#       Dirección IP privada de Node01
#   private_lan_node02
#       Dirección IP privada de Node02
#   internal_private_key_file
#       Por defecto Terraform nos permite crear una clave privada aleatoria, pero también podríamos definir la nuestra, es por eso que aquí se pasa como parámetro la clave que se utilizará para conectar a los Nodos internos, luego de realizar el salto a través del jump_host
#   external_private_key_file
#       Por defecto Terraform nos permite crear una clave privada aleatoria, pero también podríamos definir la nuestra, es por eso que aquí se pasa como prámetro la clave que se utilizará para conectar a Master, el servidor de entrada principal que recibe las conexiones SSH en la red pública
#   ghost_url
#       FQDN de la IP pública de azure. Esta nos servirá para configurar Ingress sobre servicios HTTP/HTTPS para nuestra aplicación Ghost
#   prefix
#       Utilizado para crear un identificador único
resource "null_resource" "ansible" {
  provisioner "local-exec" {
    interpreter = [
      "/bin/bash",
      "-c"
    ]
    command    = <<-EOT
      ansible-playbook -e jump_host='${data.azurerm_public_ip.pi_k8s.ip_address}' -e admin_user='${var.ssh_user}' -e subnet_cidr_private='${azurerm_subnet.sn_k8s_private.address_prefixes[0]}' -e private_lan_master='${azurerm_network_interface.nic_k8s_master.private_ip_address}' -e private_lan_node01='${var.workers["Node01"].ip}' -e private_lan_node02='${var.workers["Node02"].ip}' -e internal_private_key_file='${local.internal_private_key_file}' -e external_private_key_file='${local.external_private_key_file}' -e ghost_url='${data.azurerm_public_ip.pi_k8s.fqdn}' -e prefix='${var.prefix}' ../ansible/playbooks/create.yml
    EOT
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
}
