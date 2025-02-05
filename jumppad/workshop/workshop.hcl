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

resource "chapter" "task_3" {
  title = "Introduction"

  page "intro" {
    content = template_file("docs/task_3/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "book" "better_together" {
  title = "Building a Terraform Provider"

  chapters = [
    resource.chapter.introduction,
    resource.chapter.task_3,
  ]
}


output "book" {
  value = resource.book.better_together
}