terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.22.0"
    }
  }
}

provider "docker" {}

resource "docker_container" "my_container" {
  image = var.projet_devops
  name  = "projet-devops-container"

  ports {
    internal = 3000
    external = 3000
  }

#  provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ec2-user"  # Utilisateur SSH sur la machine distante
#       private_key = file("~/.ssh/id_rsa")  # Chemin vers la clé privée SSH
#       host        = self.public_ip  # Adresse IP publique de l'instance
#     }

#     inline = [
#       "sudo yum update -y",  # Mettre à jour le système (pour Amazon Linux)
#       "sudo yum install -y git",  # Installer Git (pour Amazon Linux)
#       "git clone https://github.com/alexandreelkhoury/Projet-Devops.git",  # Remplacez avec l'URL de votre référentiel Git
#       "cd your_react_app",
#       "npm install",  # Installer les dépendances de l'application React
#       "npm start &",  # Démarrer l'application React en arrière-plan
#     ]
#   }
}

resource "docker_network" "nginx" {
  name   = "docknet"
  driver = "bridge"
}

resource "docker_image" "nginx" {
  name         = var.nginx_image
  keep_locally = false
}

resource "docker_container" "second-container" {
  name  = "second-container"
  image = var.nginx_image

  networks_advanced {
    name    = docker_network.nginx.name
    aliases = ["docknet"]
  }

  restart = "unless-stopped"
  destroy_grace_seconds = 30
  must_run = true
  memory = 256

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  ports {
    internal = 80
    external = 8080
    ip       = "0.0.0.0"
  }

  depends_on = [docker_container.my_container]

  provisioner "local-exec" {
    command = "echo ${"Hello world !"} >> private_ips.txt"
  }
}

# jenkins

# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = "my-context"
# }

# resource "kubernetes_namespace" "jenkins" {
#   metadata {
#     name = "jenkins"
#   }
# }

# resource "kubernetes_deployment" "example" {
#   metadata {
#     name = "terraform-example"
#     labels = {
#       test = "MyExampleApp"
#     }
#   }

#   spec {
#     replicas = 3

#     selector {
#       match_labels = {
#         test = "MyExampleApp"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           test = "MyExampleApp"
#         }
#       }

#       spec {
#         container {
#           image = "nginx:1.21.6"
#           name  = "example"

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }

#           liveness_probe {
#             http_get {
#               path = "/"
#               port = 80

#               http_header {
#                 name  = "X-Custom-Header"
#                 value = "Awesome"
#               }
#             }

#             initial_delay_seconds = 3
#             period_seconds        = 3
#           }
#         }
#       }
#     }
#   }
# }


# Cours

# terraform init
# terraform apply
# terraform destroy

# resource "nom de la ressource à voir sur /registry" "le nom que l'on veut donner {
#   name         = var.name
#   keep_locally = false
# }