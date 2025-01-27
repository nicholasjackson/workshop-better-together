variable "docs_url" {
  description = "The URL for the documentation site"
  default     = "http://localhost"
}

variable "prismarine_url" {
  description = "The URL for prismarine"
  default     = "http://localhost:8080"
}

variable "minecraft_url" {
  description = "The URL for the Minecraft server"
  default     = "localhost"
}

variable "api_url" {
  description = "The URL for the Minecraft API"
  default     = "http://localhost:9090"
}

resource "chapter" "introduction" {
  title = "Introduction"

  page "introduction" {
    content = template_file("docs/introduction/intro.mdx", {
      docs_url       = variable.docs_url
      prismarine_url = variable.prismarine_url
      minecraft_url  = variable.minecraft_url
      api_url        = variable.api_url
    })
  }
}