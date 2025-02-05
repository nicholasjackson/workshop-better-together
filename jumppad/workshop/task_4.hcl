resource "chapter" "task_4" {
  title = "4.Use AAP to update the shared Minecraft server access list"

  page "intro" {
    content = template_file("docs/task_4/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}