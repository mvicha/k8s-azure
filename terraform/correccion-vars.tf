variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "eastus"
}

variable "storage_account" {
  type = string
  description = "Nombre para la storage account"
  default = "mvillasa"
}

# No se utiliza. La solución automáticamente crea una clave SSH para la conexión interna y externa.
variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/test.pem.pub" # o la ruta correspondiente. Si esta variable o private_key_path están vacías se genera una llave automáticamente
}

# No se utiliza. La solución automáticamente crea una clave SSH para la conexión interna y externa.
variable "private_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/test.pem" # o la ruta correspondiente. Si esta variable o public_key_path están vacías se genera una llave automáticamente
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "azureuser"
}
