resource "digitalocean_app" "statamic" {
  spec {
    name = "statamic-app"
    region = var.region

    service {
      name  = "web"

      image {
        registry_type = "DOCR"
        repository    = var.repository
        tag           = var.image_tag
      }

      http_port = 80
      instance_size_slug = "basic-xxs"
      instance_count     = 1

      env {
        key   = "APP_ENV"
        value = var.app_env
      }
      env {
        key   = "APP_KEY"
        value = var.app_key
        scope = "RUN_AND_BUILD_TIME"
      }
      # Add more envs as needed, or pass as variables
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
      env {
        key   = "AWS_DEFAULT_REGION"
        value = var.region
        scope = "RUN_AND_BUILD_TIME"
      }
      env {
        key   = "AWS_ENDPOINT"
        value = var.aws_endpoint
        scope = "RUN_AND_BUILD_TIME"
      }
      env {
        key   = "APP_URL"
        value = var.app_url
        scope = "RUN_AND_BUILD_TIME"
      }
    }
  }
}
