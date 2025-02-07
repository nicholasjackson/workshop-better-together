resource "chapter" "task_3" {
  title = "3.Packer and Terraform with AAP"

  tasks = {
    packer_build = resource.task.packer_build
    update_terraform = resource.task.update_terraform
    update_tfvars = resource.task.update_tfvars
    terraform_apply = resource.task.terraform_apply
  }

  page "intro" {
    content = template_file("docs/task_3/intro.mdx", {
      docs_url     = variable.docs_url
      machine_url  = variable.machine_url
    })
  }
  page "step_1" {
    content = template_file("docs/task_3/step_1.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
  page "step_2" {
    content = template_file("docs/task_3/step_2.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
      ansible_pass = variable.ansible_pass
    })
  }
}

resource "task" "packer_build" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "check packer image" {
    description = "Success - Packer image minecraft-vm-ansible.qcow2 exists"

    check {
      script = <<-EOF
        validate file exists "/workshop/images/minecraft_vm_ansible/minecraft-vm-ansible.qcow2"
      EOF

      failure_message = "Validation Failed - Packer image minecraft-vm-ansible.qcow2 not found"
    }

    solve {
      script = <<-EOF
      EOF

      timeout = 60
    }
  }
}

resource "task" "update_terraform" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "check terraform" {
      description = "Success - aap.tf exists in your Terraform configuration"

      check {
        script = <<-EOF
          validate file exists "/workshop/src/working/terraform/aap.tf"
        EOF

        failure_message = "Validation Failed - aap.tf not found in your Terraform configuration"
      }

      solve {
        script = <<-EOF
        EOF

        timeout = 60
      }
    }
}

resource "task" "update_tfvars" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "check terraform" {
      description = "Success - "

      check {
        script = <<-EOF
        EOF

        failure_message = "Validation Failed - "
      }

      solve {
        script = <<-EOF
        EOF

        timeout = 60
      }
    }
}

resource "task" "terraform_apply" {
  prerequisites = []

  config {
    user   = "root"
    target = variable.vscode
  }

  condition "check terraform" {
      description = "Success - "

      check {
        script = <<-EOF
        EOF

        failure_message = "Validation Failed - "
      }

      solve {
        script = <<-EOF
        EOF

        timeout = 60
      }
    }
}