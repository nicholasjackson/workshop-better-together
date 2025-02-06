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
# https://registry.terraform.io/providers/ansible/aap/latest/docs/resources/inventory






# Create a new AAP host for the GCP minecraft server set any required variables
# https://registry.terraform.io/providers/ansible/aap/latest/docs/resources/host






# Execute the Job Template to update the minecraft server for access using existing job template - minecraft_whitelist
# credentials are preconfigured and using the same credentials as task 3 no changes are required to the AAP job template
# https://registry.terraform.io/providers/ansible/aap/latest/docs/resources/job
