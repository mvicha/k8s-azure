variable "virtual_network_cidr" {
  default = "192.168.0.0/16"
}

variable "subnet_cidr_private" {
  default = "192.168.1.0/24"
}

variable "private_lan_master" {
  default = "192.168.1.100"
}

variable "mysql_ghost_database" {
  default = "ghost"
}

variable "mysql_ghost_username" {
  default = "ghost"
}

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