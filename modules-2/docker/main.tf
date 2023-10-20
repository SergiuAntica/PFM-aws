resource "docker_image" "this" {
  name = var.name
  build {
    context  = var.context
    tag      = [var.tag]
    platform = var.platform
  }
}
