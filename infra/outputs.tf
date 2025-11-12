output "app_id" {
  value = module.app.app_id # Or use another output from the app module if you want the live_url
}

output "app_live_url" {
  value = module.app.live_url
}

output "mysql_host" {
  value = module.mysql.db_host
}

# output "spaces_bucket" {
#   value = module.spaces.bucket_name
# }

# output "mysql_host" {
#   value = digitalocean_database_cluster.mysql.host
# }

# output "redis_host" {
#  value = digitalocean_database_cluster.redis.host
# }

# output "spaces_bucket" {
#   value = digitalocean_spaces_bucket.spaces.name
# }
