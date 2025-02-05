variable "docs_url" {
  description = "The URL for the documentation site"
  default     = "http://localhost"
}

variable "machine_url" {
  description = "The URL for the Instruqt machine"
  default     = "localhost"
}

resource "chapter" "introduction" {
  title = "Introduction"

  page "introduction" {
    content = template_file("docs/introduction/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}


resource "chapter" "task_2" {
  title = "HCP Vault with Ansible Automation Plaform"

  page "intro" {
    content = template_file("docs/task_2/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "chapter" "task_3" {
  title = "Packer with Ansible provisioner"

  page "intro" {
    content = template_file("docs/task_3/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "chapter" "task_4" {
  title = "Use Ansible Automation Platform to update the shared Minecraft server access list"

  page "intro" {
    content = template_file("docs/task_4/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "book" "better_together" {
  title = "Use Packer with Ansible provisioner to build a secure Minecraft server image"

  chapters = [
    resource.chapter.introduction,
    resource.chapter.task_2,
    resource.chapter.task_3,
    resource.chapter.task_4
  ]
}


output "book" {
  value = resource.book.better_together
}