resource "chapter" "task_2" {
  title = "2.Vault with AAP"

  tasks = {
    vault_login = resource.task.vault_login
    read_kv_secrets = resource.task.read_kv_secrets
    configure_aap_vault_creds = resource.task.configure_aap_vault_creds
    configure_machine_creds = resource.task.configure_machine_creds
  }

  page "intro" {
    content = template_file("docs/task_2/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
  page "step_1" {
    content = template_file("docs/task_2/step_1.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
      ansible_pass = variable.ansible_pass
    })
  }
  page "step_2" {
    content = template_file("docs/task_2/step_2.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
      ansible_pass = variable.ansible_pass
    })
  }
  page "step_3" {
    content = template_file("docs/task_2/step_3.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
      ansible_pass = variable.ansible_pass
    })
  }
}

resource "task" "vault_login" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "vault_login" {
    description = "vault login successful"

    check {
      script = <<-EOF
      EOF

      failure_message = "check the environment variable and try again"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}

resource "task" "read_kv_secrets" {
  prerequisites = []

  config {
    user   = "root"
     target = variable.vscode
  }

  condition "read_kv_secrets" {
    description = "Success"

    check {
      script = <<-EOF
      EOF

      failure_message = "check the environment variable and try again"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}

resource "task" "configure_aap_vault_creds" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "configure_aap_vault_creds" {
    description = "Success"

    check {
      script = <<-EOF
      EOF

      failure_message = "check the environment variable and try again"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}

resource "task" "configure_machine_creds" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "configure_machine_creds" {
    description = "Success"

    check {
      script = <<-EOF
      EOF

      failure_message = "check the environment variable and try again"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}