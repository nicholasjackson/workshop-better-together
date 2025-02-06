resource "chapter" "task_2" {
  title = "2.Vault with AAP"

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
    })
  }
  page "step_2" {
    content = template_file("docs/task_2/step_2.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
  page "step_3" {
    content = template_file("docs/task_2/step_3.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "task" "vault_login" {
  prerequisites = []

  # config {
  #   user   = "root"
  # }

  # condition "vault login" {
  #   description = "vault login successful"

  #   check {
  #     script = <<-EOF
  #       vault status
  #     EOF

  #     failure_message = "check the environment variable and try again"
  #   }

  #   solve {
  #     script = <<-EOF
  #     EOF

  #     timeout = 60
  #   }
  # }
}

resource "task" "read_kv_secrets" {
  prerequisites = []

  # config {
  #   user   = "root"
  # }

  # condition "vault login" {
  #   description = "vault login successful"

  #   check {
  #     script = <<-EOF
  #       vault status
  #     EOF

  #     failure_message = "check the environment variable and try again"
  #   }

  #   solve {
  #     script = <<-EOF
  #     EOF

  #     timeout = 60
  #   }
  # }
}

resource "task" "configure_aap_vault_creds" {
  prerequisites = []

  # config {
  #   user   = "root"
  # }

  # condition "vault login" {
  #   description = "vault login successful"

  #   check {
  #     script = <<-EOF
  #       vault status
  #     EOF

  #     failure_message = "check the environment variable and try again"
  #   }

  #   solve {
  #     script = <<-EOF
  #     EOF

  #     timeout = 60
  #   }
  # }
}