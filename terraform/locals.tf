# Este fichero se utiliza para guardar en variables locales el resultado del análisis del tipo de clave SSH que se utilizará
# Existen 2 opciones:
#   - Que Terraform genere las claves privadas automáticamente
#   - Que las claves sean provistas por el usuarios
# Los resultados se guardan en estas variables:
#   - internal_public_key_data: valor de la clave pública para conectar a los nodos internos
#   - external_public_key_data: valor de la clave pública para conectar al nodo master por medio de la IP pública
#   - internal_private_key_file: Ubicación de la clave privada para conectar a los nodos internos
#   - external_private_key_file: Ubicación de la clave privada para conectar al nodo master por medio de la IP pública
locals {
  # LAN SSH Key data
  internal_public_key_data  = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? file(var.public_key_path) : tls_private_key.internal_ssh.public_key_openssh

  # Public SSH Key data
  external_public_key_data  = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? file(var.public_key_path) : tls_private_key.external_ssh.public_key_openssh

  # Private SSH Key file location
  internal_private_key_file = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? var.private_key_path : "resources/internal.pem"
  external_private_key_file = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? var.private_key_path : "resources/external.pem"
}
