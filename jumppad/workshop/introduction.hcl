resource "chapter" "introduction" {
  title = "Introduction"

  page "introduction" {
    content = template_file("docs/introduction/intro.mdx", {
      docs_url    = variable.docs_url
      machine_url = variable.machine_url
    })
  }
}