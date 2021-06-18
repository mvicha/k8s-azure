locals {
  # LAN SSH Key data
  internal_public_key_data  = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? file(var.public_key_path) : tls_private_key.internal_ssh.public_key_openssh

  # Public SSH Key data
  external_public_key_data  = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? file(var.public_key_path) : tls_private_key.external_ssh.public_key_openssh

  # Private SSH Key file location
  internal_private_key_file = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? var.private_key_path : "resources/internal.pem"
  external_private_key_file = length(var.public_key_path) > 0 && length(var.private_key_path) > 0 ? var.private_key_path : "resources/external.pem"
}
