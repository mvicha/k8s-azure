variable "virtual_network_cidr" {
  type        = string
  description = "CIDR de la red"
  default     = "192.168.0.0/16"
}

variable "subnet_cidr_private" {
  type        = string
  description = "CIDR de la subred privada"
  default     = "192.168.1.0/24"
}

variable "private_lan_master" {
  type        = string
  description = "Dirección IP privada del nodo Master"
  default     = "192.168.1.100"
}

variable "mysql_ghost_database" {
  type        = string
  description = "Nombre de la DB de ghost"
  default     = "ghost"
}

variable "vm_size_master" {
  type        = string
  description = "Tipo de VM que se utilizará para el nodo Master"
  default     = "Standard_A2_v2"
}

# Variables de Worker Nodes
variable "workers" {
  default = {
    Node01: {
      "ip"      = "192.168.1.101"
      "vm_size" = "Standard_A1_v2"
    },
    Node02: {
      "ip"      = "192.168.1.102"
      "vm_size" = "Standard_A1_v2"
    }
  }
}
