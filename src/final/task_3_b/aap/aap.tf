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
  description = "Ansible Automation Platform username"
}

variable "aap_password" {
  type = string
  description = "Ansible Automation Platform password"
}

variable "ansible_port" {
  type = number
  description = "Ansible port"
  default = 2222
}

variable "minecraft_hostname" {
  type = string
  description = "public address or dns name of Minecraft VM"
}

variable "minecraft_usernames" {
  type = list(string)
  description = "minecraft usernames for access list"
  default = []
}

variable "job_template_id" {
  type = string
  description = "Job template id"
}

# Create a new AAP inventory for the shared minecraft server
resource "aap_inventory" "dedicated_minecraft" {
  name = "minecraft_dedicated"
  description = "Dedicated Minecraft Server"
}

# Create a new AAP host for the minecraft server
resource "aap_host" "vm_hosts" {
  inventory_id = aap_inventory.dedicated_minecraft.id
  name         = var.minecraft_hostname  # Use the hostname for each VM
  variables    = jsonencode({
    "ansible_host"     : "${var.minecraft_hostname}",
    "ansible_port"     : var.ansible_port
})

# we can probably use a http datasource for lookup here.

resource "aap_job" "minecraft_whitelist" {
  job_template_id = var.job_template_id
  inventory_id    = aap_inventory.dedicated_minecraft.id
  extra_vars      = jsonencode({
    "minecraft_usernames" : var.minecraft_usernames
  })
  
}