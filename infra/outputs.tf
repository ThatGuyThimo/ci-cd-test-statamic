output "app_url" {
  value = digitalocean_app.statamic.live_url
}

output "mysql_host" {
  value = digitalocean_database_cluster.mysql.host
}

output "redis_host" {
  value = digitalocean_database_cluster.redis.host
}

output "spaces_bucket" {
  value = digitalocean_spaces_bucket.minio.name
}
