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

variable "prefix" {
  description = "Prefijo que se utilizará para crear nombre únicos"
}

variable "ghost_dns_alias" {
  description = "Alias que se utilizará para acceder via URL al servidor de Ghost"
}

variable "my_ip" {
  description = "Dirección IP de la máquina local. Necesaria para conectar a los servidores vía SSH"
}

variable "location" {
  type        = string
  description = "Región de Azure donde crearemos la infraestructura"
}

variable "storage_account" {
  type        = string
  description = "Nombre para la storage account"
}

# No se utiliza. La solución automáticamente crea una clave SSH para la conexión interna y externa.
variable "public_key_path" {
  type        = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default     = ""
}

# No se utiliza. La solución automáticamente crea una clave SSH para la conexión interna y externa.
variable "private_key_path" {
  type        = string
  description = "Ruta para la clave privada de acceso a las instancias"
  default     = ""
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
}
