resource "chapter" "task_3" {
  title = "3.Packer and Terraform with AAP"

  page "intro" {
    content = template_file("docs/task_3/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}