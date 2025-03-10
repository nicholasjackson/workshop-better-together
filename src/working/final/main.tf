terraform {
  required_providers {
    aap = {
      source = "ansible/aap"
      version = "1.1.2"
    }
    
    http = {
      source = "hashicorp/http"
      version = "3.4.5"
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
  default = "https://44.210.128.100"
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

variable "job_template_name" {
  type = string
  description = "Job Template Name"
  default = "minecraft_whitelist"
}

locals {
  response_body = jsondecode(data.http.minecraft_accesslist.response_body)
  template_id = local.response_body.results[0].id
  org_id = local.response_body.results[0].organization
}

# Get the job template id by name from the AAP
data "http" "minecraft_accesslist" {
  url = "${var.aap_url}/api/controller/v2/job_templates/?name=${var.job_template_name}"
  insecure=true

  request_headers = {
    Accept        = "application/json"
    Authorization = "Basic ${base64encode("${var.aap_username}:${var.aap_password}")}"
  }
}

# To get a better understanding of the aap provider integration you can look at Task 3 code aap.tf in the terraform directory
# A key difference is you are executing an ansible job on the existing GCP minecraft server


# Create a new AAP inventory for the shared minecraft server
# https://registry.terraform.io/providers/ansible/aap/latest/docs/resources/inventory
# Hint: you will need your organization id use the locals provided (org_id). See the aap.tf file in the terraform directory in Task 3 if stuck
resource "aap_inventory" "shared_minecraft" {


}


# Create a new AAP host for the GCP minecraft server set any required variables, and add it to the created inventory
# https://registry.terraform.io/providers/ansible/aap/latest/docs/resources/host
# Hint: For access to the GCP minecraft server you will need to set minecraft_usernames
# The remote host can be managed via Ansible using the standard SSH port (22) See the aap.tf file in the terraform directory in Task 3 if stuck
resource "aap_host" "vm_hosts" {


}

# Execute the existing Job Template to update the minecraft server for access using existing job template - minecraft_whitelist
# credentials are preconfigured and using the same credentials as task 3 no changes are required to the AAP job template
# https://registry.terraform.io/providers/ansible/aap/latest/docs/resources/job
# Hint: you will need to set the job_template_id (see locals) and inventory_id
resource "aap_job" "minecraft_whitelist" {


}