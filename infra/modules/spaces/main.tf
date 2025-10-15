resource "digitalocean_spaces_bucket" "spaces" {
  name   = var.spaces_bucket
  region = var.region
  acl    = "private"
}
