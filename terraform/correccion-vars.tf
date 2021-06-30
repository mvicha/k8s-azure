variable "location" {
  type        = string
  description = "Región de Azure donde crearemos la infraestructura"
  default     = "West Europe"
}

variable "storage_account" {
  type        = string
  description = "Nombre para la storage account"
  default     = "mvillasa"
}

variable "ssh_user" {
  type        = string
  description = "Usuario para hacer ssh"
  default     = "azureuser"
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
