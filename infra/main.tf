terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.28" # or the latest stable version
    }
  }
}

provider "digitalocean" {
  token                  = var.do_token
  spaces_access_id       = var.spaces_key
  spaces_secret_key      = var.spaces_secret
}


# --------------------------
# Managed MySQL (Module)
# --------------------------
# module "mysql" {
#   source       = "./modules/mysql"
#   providers = {
#     digitalocean = digitalocean
#   }
#   cluster_name = var.cluster_name
#   cluster_size = var.cluster_size
#   db_name      = var.db_name
#   db_user      = var.db_user
#   region       = var.region
# }

# --------------------------
# Managed Redis
# --------------------------

# resource "digitalocean_database_cluster" "redis" {
#   name       = "statamic-redis"
#   engine     = "redis"
#   version    = "7"
#   size       = "db-s-1vcpu-1gb"
#   region     = var.region
#   node_count = 1
#   # do not set a password, it's auto-managed
# }


# --------------------------
# DO Spaces (Module)
# --------------------------
# module "spaces" {
#   source        = "./modules/spaces"
#   providers = {
#     digitalocean = digitalocean
#   }
#   spaces_bucket = var.spaces_bucket
#   region        = var.region
# }


# --------------------------
# App Platform (Module)
# --------------------------
module "app" {
  source        = "./modules/app"
  providers = {
    digitalocean = digitalocean
  }
  region            = var.region
  repository        = "statamic-app" # or pass as a variable if dynamic
  image_tag         = "latest"       # or pass as a variable if dynamic
  app_env           = "production"
  app_key           = var.app_key
  spaces_key        = var.spaces_key
  spaces_secret     = var.spaces_secret
  aws_endpoint      = "https://${var.spaces_bucket}.${var.region}.digitaloceanspaces.com"
  app_url           = var.app_url
  app_debug         = var.app_debug
  log_level         = var.log_level
  session_driver    = var.session_driver
  session_lifetime  = var.session_lifetime
  session_encrypt   = var.session_encrypt
  db_connection     = var.db_connection
  db_host           = var.db_host
  db_port           = var.db_port
  db_name           = var.db_name
  db_user           = var.db_user
  db_password       = var.db_password
  asset_url         = var.asset_url
}
