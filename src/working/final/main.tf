terraform {
  required_providers {
    aap = {
      source = "ansible/aap"
      version = "1.1.2"
    }
  }
}

# https://registry.terraform.io/providers/ansible/aap/latest

provider "aap" {
  host                 = var.aap_url
  username             = var.aap_username
  password             = var.aap_password
  insecure_skip_verify = true
}

variable "aap_url" {
  type = string
  description = "Ansible Automation Platform URL"
  default = "https://44.210.128.10"
}

variable "aap_username" {
  type = string
}

variable "aap_password" {
  type = string
}

variable "minecraft_hostname" {
  type = string
}

variable "minecraft_usernames" {
  type = list(string)
  description = "minecraft username to add whitelist"
}


# Create a new AAP inventory for the shared minecraft server



# Create a new AAP host for the GCP minecraft server set any required variables



# Execute the Job Template to update the minecraft server for access using existing job template - minecraft_whitelist

