variable "region" {
    default = "us-east-1"  # Variable que especifica la región de AWS, con un valor predeterminado de "us-east-1"
}

variable "public_key" {
  # Variable para especificar la clave pública utilizada para la conexión SSH a la instancia EC2
}

variable "private_key" {
  # Variable para especificar la clave privada utilizada para la conexión SSH a la instancia EC2
}

variable "key_name" {
  # Variable para especificar el nombre del par de claves utilizado para acceder a la instancia EC2
}
