resource "network" "main" {
  subnet = "10.100.0.0/16"
}

variable "docs_url" {
  description = "The URL for the documentation site"
  default     = "http://localhost"
}

variable "machine_url" {
  description = "The URL for the Minecraft server"
  default     = "minecraft.container.local.jmpd.in"
}

variable "vscode_token" {
  default = "token"
}

resource "template" "vscode_jumppad" {
  source = <<-EOF
  {
  "tabs": [
    {
      "name": "Docs",
      "uri": "${variable.docs_url}",
      "type": "browser",
      "active": true
    }
  ]
  }
  EOF

  destination = "${data("vscode")}/workspace.json"
}

resource "template" "vscode_settings" {
  source = <<-EOF
  {
      "workbench.colorTheme": "Palenight Theme",
      "editor.fontSize": 16,
      "workbench.iconTheme": "material-icon-theme",
      "terminal.integrated.fontSize": 16
  }
  EOF

  destination = "${data("vscode")}/settings.json"
}

resource "template" "bash_rc" {
  source = <<-EOF
  export PATH=$PATH:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  EOF

  destination = "${data("bash")}/.bashrc"
}

resource "container" "vscode" {
  network {
    id = resource.network.main.meta.id
  }

  image {
    name = "ghcr.io/nicholasjackson/workshop-better-together:v0.0.1"
  }

  volume {
    source      = resource.template.vscode_jumppad.destination
    destination = "/workshop/.vscode/workspace.json"
  }

  volume {
    source      = resource.template.vscode_settings.destination
    destination = "/workshop/.vscode/settings.json"
  }

  volume {
    source      = resource.template.bash_rc.destination
    destination = "/root/.bashrc"
  }

  # Workshop source
  volume {
    source      = "../src"
    destination = "/workshop/src"
  }

  environment = {
    CONNECTION_TOKEN = variable.vscode_token
    DEFAULT_FOLDER   = "/workshop"
    PATH             = "/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  }

  port {
    local  = 8000
    remote = 8000
    host   = 8000
  }

  health_check {
    timeout = "100s"

    http {
      address       = "http://localhost:8000/"
      success_codes = [200, 302, 403]
    }
  }
}

module "workshop" {
  source = "./workshop"

  variables = {
    working_directory = "/workshop"
    docs_url          = variable.docs_url
    machine_url       = variable.machine_url
    vscode            = resource.container.vscode.meta.id
  }
}

resource "docs" "docs" {
  network {
    id = resource.network.main.meta.id
  }

  image {
    name = "ghcr.io/jumppad-labs/docs:v0.5.1"
  }

  content = [
    module.workshop.output.book
  ]

  assets = "./workshop/images"
}