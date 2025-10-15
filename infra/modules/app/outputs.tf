output "app_id" {
  value = digitalocean_app.statamic.id
}

output "live_url" {
  value = digitalocean_app.statamic.live_url
}
