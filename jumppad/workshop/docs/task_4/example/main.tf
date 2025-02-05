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
  host                 = "https://44.210.128.100"
  username             = var.aap_username
  password             = var.aap_password
  insecure_skip_verify = true
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


# Create a new AAP inventory for the shared minecraft server
resource "aap_inventory" "shared_minecraft" {
  name = "minecraft_gcp"
  description = "Shared Minecraft Server"
}

# Create a new AAP host for the miecraft server
resource "aap_host" "vm_hosts" {
  inventory_id = aap_inventory.shared_minecraft.id
  name         = each.value.hostname  # Use the hostname for each VM
  variables    = jsonencode({
    "ansible_host"     : "${var.minecraft_hostname}" #ip address or dns name of the shared GCP Minecraft VM
})


# Execute the Job Template to update the minecraft server for access using existing job template - minecraft_whitelist
# note: the job template should be created in the AAP server and is already associated with the machine credentials configured in task_2

