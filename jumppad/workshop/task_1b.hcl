resource "chapter" "task_1b" {
  title = "2. Configure Vault to Access the Treasure"
  tasks = {
    apply_terraform_configuration = resource.task.apply_terraform_configuration
  }

  page "Introduction" {
    content = template_file("docs/task_1b/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}