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
}

variable "job_template_id" {
  type = string
  description = "Job template id"
  default = null
}

variable "job_template_name" {
  type = string
  description = "Job template name"
  default = "minecraft_whitelist"
}
variable "trigger_run" {
  type = string
  default = "1"
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

locals {
  response_body = jsondecode(data.http.minecraft_accesslist.response_body)
  template_id = local.response_body.results[0].id
  org_id = local.response_body.results[0].organization
}

# Create a new AAP inventory for the your minecraft server
resource "aap_inventory" "dedicated_minecraft" {
  name = "minecraft_dedicated"
  description = "Dedicated Minecraft Server"
  organization = local.org_id
}

# Create a new AAP host for the minecraft server
resource "aap_host" "vm_hosts" {
  inventory_id = aap_inventory.dedicated_minecraft.id
  name         = var.minecraft_hostname  # Use the hostname for each VM
  variables    = jsonencode({
    "ansible_host"     : "${var.minecraft_hostname}",
    "ansible_port"     : var.ansible_port
})
}

resource "aap_job" "minecraft_whitelist" {
  depends_on = [ time_sleep.wait_30_seconds ]
  job_template_id = local.template_id
  inventory_id    = aap_inventory.dedicated_minecraft.id
  extra_vars      = jsonencode({
    "minecraft_usernames" : var.minecraft_usernames
  })

  triggers = {
    "${var.minecraft_hostname}" : "${var.trigger_run}"
  }
  
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [resource.libvirt_domain.domain-ubuntu , resource.libvirt_volume.ubuntu-qcow2 ]
  create_duration = "30s"
}


output "aap_job_url" {
  value = "https://44.210.128.100${aap_job.minecraft_whitelist.url}"
}

output "aap_job_type" {
  value = aap_job.minecraft_whitelist.job_type
}

output "aap_job_status" {
  value = aap_job.minecraft_whitelist.status
}