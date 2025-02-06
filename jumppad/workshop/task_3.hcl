resource "chapter" "task_3" {
  title = "3.Packer and Terraform with AAP"

   page "intro" {
    content = template_file("docs/task_3/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
  page "part_1" {
    content = template_file("docs/task_3/part_1.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
  page "part_2" {
    content = template_file("docs/task_3/part_2.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}