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

			http_port = 8080
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
				key   = "AWS_BUCKET"
				value = var.spaces_bucket
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "AWS_URL"
				value = "https://${var.spaces_bucket}.${var.region}.digitaloceanspaces.com"
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "AWS_USE_PATH_STYLE_ENDPOINT"
				value = "false"
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "APP_URL"
				value = var.app_url
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "ASSET_URL"
				value = var.asset_url
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "APP_DEBUG"
				value = var.app_debug
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "LOG_LEVEL"
				value = var.log_level
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "DB_CONNECTION"
				value = var.db_connection
				scope = "RUN_AND_BUILD_TIME"  
			}
			env {
				key   = "DB_HOST"
				value = var.db_host
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "DB_PORT"
				value = var.db_port
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "DB_DATABASE"
				value = var.db_name
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "DB_USERNAME"
				value = var.db_user
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "DB_PASSWORD"
				value = var.db_password
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "SESSION_DRIVER"
				value = var.session_driver
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "SESSION_LIFETIME"
				value = var.session_lifetime
				scope = "RUN_AND_BUILD_TIME"
			}
			env {
				key   = "SESSIION_ENCRYPT"
				value = var.session_encrypt
				scope = "RUN_AND_BUILD_TIME"
			}
		}
	}
}