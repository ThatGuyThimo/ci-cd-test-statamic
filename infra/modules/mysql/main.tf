resource "digitalocean_database_cluster" "mysql" {
  name       = var.cluster_name
  engine     = "mysql"
  version    = "8"
  size       = var.cluster_size
  region     = var.region
  node_count = 1
}

resource "digitalocean_database_db" "statamic_db" {
  cluster_id = digitalocean_database_cluster.mysql.id
  name       = var.db_name
}

resource "digitalocean_database_user" "statamic_user" {
  cluster_id = digitalocean_database_cluster.mysql.id
  name       = var.db_user
}
