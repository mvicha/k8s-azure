variable "admin_user" {
  description = "Usuario que se creará en la VM como admin"
  default = "azureuser"
}

variable "virtual_network_cidr" {
  default = "192.168.0.0/16"
}

variable "subnet_cidr_private" {
  default = "192.168.1.0/24"
}

variable "private_lan_master" {
  default = "192.168.1.100"
}

variable "private_lan_node01" {
  default = "192.168.1.101"
}

variable "private_lan_node02" {
  default = "192.168.1.102"
}

variable "mysql_ghost_database" {
  default = "ghost"
}

variable "mysql_ghost_username" {
  default = "ghost"
}
