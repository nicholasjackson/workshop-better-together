resource "chapter" "task_2" {
  title = "2.Vault with AAP"

  page "intro" {
    content = template_file("docs/task_2/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}