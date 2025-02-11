resource "chapter" "task_1b" {
  title = "2. Configure Vault to Access the Treasure"

  page "Introduction" {
    content = template_file("docs/task_1b/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }

  page "step1" {
    content = template_file("docs/task_1b/step_1.mdx", {
      docs_url     = variable.docs_url
      machine_url  = variable.machine_url
      ansible_pass = variable.ansible_pass
    })
  }

  page "step2" {
    content = template_file("docs/task_1b/step_2.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }

  page "step3" {
    content = template_file("docs/task_1b/step_3.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }

  page "step4" {
    content = template_file("docs/task_1b/step_4.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}