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
# Managed MySQL
# --------------------------
# resource "digitalocean_database_cluster" "mysql" {
#   name       = var.cluster_name
#   engine     = "mysql"
#   version    = "8"
#   size       = var.cluster_size
#   region     = var.region
#   node_count = 1
#   depends_on = [digitalocean_database_cluster.mysql]
# }

# resource "digitalocean_database_db" "statamic_db" {
#   cluster_id = digitalocean_database_cluster.mysql.id
#   name       = var.db_name
# }

# resource "digitalocean_database_user" "statamic_user" {
#   cluster_id = digitalocean_database_cluster.mysql.id
#   name       = var.db_user
#   # DO NOT set password, it's auto-managed
# }

# --------------------------
# Managed Redis
# --------------------------
#resource "digitalocean_database_cluster" "redis" {
#  name       = "statamic-redis"
#  engine     = "redis"
#  version    = "7"
#  size       = "db-s-1vcpu-1gb"
#  region     = var.region
#  node_count = 1
#  password   = var.redis_password
#}

# --------------------------
# DO Spaces / MinIO
# --------------------------
# resource "digitalocean_spaces_bucket" "spaces" {
#   name   = var.spaces_bucket
#   region = var.region
#   acl    = "private"
# }

# --------------------------
# App Platform
# --------------------------
resource "digitalocean_app" "statamic" {
  spec {
    name = "statamic-app"

    service {
      name  = "web"
      image {
        registry_type = "DOCR"
        registry      = var.app_image
        repository    = var.app_repository
        # registry      = "registry.digitalocean.com/migrationtest"
        # repository    = "statamic-app"
        tag           = "latest"
      }
      http_port = 80
      instance_size_slug = "basic-xxs"
      instance_count     = 1

      env {
        key   = "APP_ENV"
        value = "production"
      }
      env {
        key   = "APP_KEY"
        value = var.app_key
        scope = "RUN_AND_BUILD_TIME"
      }
    #   env {
    #     key   = "DB_HOST"
    #     value = digitalocean_database_cluster.mysql.host
    #   }
    #   env {
    #     key   = "DB_PORT"
    #     value = digitalocean_database_cluster.mysql.port
    #   }
    #   env {
    #     key   = "DB_DATABASE"
    #     value = digitalocean_database_db.statamic_db.name
    #   }
    #   env {
    #     key   = "DB_USERNAME"
    #     value = digitalocean_database_user.statamic_user.name
    #   }
    #   env {
    #     key   = "DB_PASSWORD"
    #     value = digitalocean_database_user.statamic_user.password
    #   }

#      env {
#        key   = "REDIS_HOST"
#        value = digitalocean_database_cluster.redis.host
#      }
#      env {
#        key   = "REDIS_PASSWORD"
#        value = digitalocean_database_cluster.redis.password
#      }
#      env {
#        key   = "REDIS_PORT"
#        value = digitalocean_database_cluster.redis.port
#      }

    #   env {
    #     key   = "SPACES_BUCKET"
    #     value = digitalocean_spaces_bucket.spaces.name
    #   }
      env {
        key   = "AWS_ACCESS_KEY_ID"
        value = var.spaces_key
        scope = "RUN_AND_BUILD_TIME"
      }
      env {
        key   = "AWS_SECRET_ACCESS_KEY"
        value = var.spaces_secret
        scope = "RUN_AND_BUILD_TIME"
      }
    #   env {
    #     key   = "AWS_BUCKET"
    #     value = digitalocean_spaces_bucket.spaces.name
    #   }
      env {
        key   = "AWS_DEFAULT_REGION"
        value = var.region
      }
      env {
        key   = "AWS_ENDPOINT"
        value = "https://${var.spaces_bucket}.${var.region}.digitaloceanspaces.com"
      }
    }
  }
}
