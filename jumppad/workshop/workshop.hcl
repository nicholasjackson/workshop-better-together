variable "docs_url" {
  description = "The URL for the documentation site"
  default     = "http://localhost"
}

variable "machine_url" {
  description = "The URL for the Instruqt machine"
  default     = "localhost"
}

variable "vscode" {
  description = "The target for the vscode container"
  default     = "vscode"
}

variable "ansible_pass" {
  description = "The shared password for the ansible server"
  default     = "Hashicorp123!sko2025"
}

variable "shared_minecraft_instance" {
  default = "sko-minecraft.hashicraft.com"
}

variable "vault_url" {
  default = "https://skoaap-public-vault-8683511a.d19fbab7.z1.hashicorp.cloud:8200"
}


resource "book" "better_together" {
  title = "Terrafom, Vault & Packer, with Ansible Automation Platform (AAP)"

  chapters = [
    resource.chapter.introduction,
    resource.chapter.task_1,
    resource.chapter.task_1b,
    resource.chapter.task_2,
    resource.chapter.task_3,
    resource.chapter.task_4
  ]
}

output "book" {
  value = resource.book.better_together
}