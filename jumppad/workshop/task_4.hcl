resource "chapter" "task_4" {
  title = "Task 4"

  tasks = {
    final_task = resource.task.final_task
  }

  page "intro" {
    content = template_file("docs/task_4/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
      shared_minecraft_instance = variable.shared_minecraft_instance
    })
  }

  page "step_1" {
    content = template_file("docs/task_4/step_1.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
      shared_minecraft_instance = variable.shared_minecraft_instance
    })
  }
}

resource "task" "final_task" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "check final_task" {
    description = "Success - Confirm you have access using the Minecraft client"

    check {
      script = <<-EOF
      EOF
      failure_message = "Validation Failed"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}