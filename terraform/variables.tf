variable "virtual_network_cidr" {
  description = "CIDR de la red"
  default     = "192.168.0.0/16"
}

variable "subnet_cidr_private" {
  description = "CIDR de la subred privada"
  default     = "192.168.1.0/24"
}

variable "private_lan_master" {
  description = "Dirección IP privada del nodo Master"
  default     = "192.168.1.100"
}

variable "mysql_ghost_database" {
  description = "Nombre de la DB de ghost"
  default     = "ghost"
}

# Variables de Worker Nodes
variable "workers" {
  default = {
    Node01: {
      "ip"   = "192.168.1.101"
    },
    Node02: {
      "ip"   = "192.168.1.102"
    }
  }
}
