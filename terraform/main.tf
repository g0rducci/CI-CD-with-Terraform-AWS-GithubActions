terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"  // Versión mínima requerida del proveedor de AWS
    }
  }
  backend "s3" {
    key = "aws/ec2-deploy/terraform.tfstate"  // Ruta y nombre de archivo para el estado de Terraform en S3
  }
}

provider "aws" {
  region = var.region  // Región de AWS proporcionada a través de la variable var.region
}

resource "aws_instance" "servernode" {
  ami                    = "ami-052efd3df9dad4825"  // ID de la AMI utilizada para la instancia EC2
  instance_type          = "t2.micro"  // Tipo de instancia EC2
  key_name               = aws_key_pair.deploy.key_name  // Nombre del par de claves de AWS utilizado para acceder a la instancia
  vpc_security_group_ids = [aws_security_group.maingroup.id]  // ID del grupo de seguridad de VPC asociado a la instancia
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile.name  // Nombre del perfil IAM asociado a la instancia EC2
  connection {
    type        = "ssh"
    host        = self.public_ip  // Dirección IP pública de la instancia EC2
    user        = "ubuntu"  // Nombre de usuario utilizado para la conexión SSH
    private_key = var.private_key  // Clave privada utilizada para la conexión SSH
    timeout     = "4m"  // Tiempo de espera para la conexión SSH
  }
  tags = {
    "name" = "DeployVM"  // Etiqueta "name" con el valor "DeployVM" para la instancia EC2
  }
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"  // Nombre del perfil de instancia IAM
  role = "ECR-LOGIN-AUTO"  // Nombre del rol IAM asociado al perfil de instancia
}

resource "aws_security_group" "maingroup" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""  // Descripción de la regla de salida
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""  // Descripción de la regla de entrada
      from_port        = 22  // Puerto de origen permitido
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"  // Protocolo permitido
      security_groups  = []
      self             = false
      to_port          = 22  // Puerto de destino permitido
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""  // Descripción de la regla de entrada
      from_port        = 80  // Puerto de origen permitido
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"  // Protocolo permitido
      security_groups  = []
      self             = false
      to_port          = 80  // Puerto de destino permitido
    }
  ]
}

resource "aws_key_pair" "deploy" {
  key_name   = var.key_name  // Nombre del par de claves utilizado para acceder a la instancia EC2
  public_key = var.public_key  // Clave pública asociada al par de claves
}

output "instance_public_ip" {
  value     = aws_instance.servernode.public_ip  // Dirección IP pública de la instancia EC2
  sensitive = true  // Se marca como información sensible para evitar que se muestre en texto plano en la salida
}
