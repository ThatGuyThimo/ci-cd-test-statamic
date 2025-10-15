output "db_host" {
  value = digitalocean_database_cluster.mysql.host
}

output "db_name" {
  value = digitalocean_database_db.statamic_db.name
}

output "db_user" {
  value = digitalocean_database_user.statamic_user.name
}
