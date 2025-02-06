resource "chapter" "task_1" {
  title = "1.Deploy a Minecraft server"

  tasks = {
    create_terraform_configuration = resource.task.create_terraform_configuration
  }

  page "intro" {
    content = template_file("docs/task_1/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }

   page "intro" {
    content = template_file("docs/task_1/part_1.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "task" "create_terraform_configuration" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "terraform created" {
    description = "Terraform configuration has been created"

    check {
      script = <<-EOF
      validate file exists "/workshop/src/working/task1_terraform/main.tf"
      EOF

      failure_message = "Please create and run the Terraform configuration"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}