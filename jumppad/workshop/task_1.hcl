resource "chapter" "task_1" {
  title = "1.Deploy a Minecraft server"

  tasks = {
    apply_terraform_configuration = resource.task.apply_terraform_configuration
  }

  page "intro" {
    content = template_file("docs/task_1/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }

   page "part_1" {
    content = template_file("docs/task_1/part_1.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}

resource "task" "apply_terraform_configuration" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "terraform created" {
    description = "Terraform configuration has been created"

    check {
      script = <<-EOF
      validate file exists "/workshop/src/working/terraform/main.tf"
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



# resource "task" "connect_to_minecraft" {
#   prerequisites = []

#   # config {
#   #   user   = "root"
#   #   target = variable.vscode
#   # }

#   # condition "terraform created" {
#   #   description = "Terraform configuration has been created"

#   #   check {
#   #     script = <<-EOF
#   #     validate file exists "/workshop/src/working/terraform/main.tf"
#   #     EOF

#   #     failure_message = "Please create and run the Terraform configuration"
#   #   }

#   #   solve {
#   #     script = <<-EOF
#   #     EOF

#   #     timeout = 60
#   #   }
#   # }
# }


