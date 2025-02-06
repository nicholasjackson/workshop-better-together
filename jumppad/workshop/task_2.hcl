resource "chapter" "task_2" {
  title = "2.Vault with AAP"

  page "intro" {
    content = template_file("docs/task_2/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
  page "part_1" {
    content = template_file("docs/task_2/part_1.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
  page "part_2" {
    content = template_file("docs/task_2/part_2.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "task" "vault_login" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "vault login" {
    description = "retrieved the vault secrets"

    check {
      script = <<-EOF
      EOF

      failure_message = "Please try again"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}