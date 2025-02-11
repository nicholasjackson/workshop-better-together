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
  default     = ""
}

variable "shared_minecraft_instance" {
  default = "sko-minecraft.hashicraft.com"
}

resource "book" "better_together" {
  title = "Terrafom, Vault & Packer, with Ansible Automation Platform (AAP)"

  chapters = [
    resource.chapter.introduction,
    resource.chapter.task_1,
    resource.chapter.task_2,
    resource.chapter.task_3,
    resource.chapter.task_4
  ]
}

output "book" {
  value = resource.book.better_together
}