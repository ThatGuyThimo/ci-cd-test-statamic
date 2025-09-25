variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "app_key" {
  description = "Laravel APP_KEY"
  type        = string
  sensitive   = true
}

variable "app_image" {
  description = "Docker image for Statamic app (DOCR)"
  type        = string
}

variable "region" {
  description = "DO region"
  default     = "ams3"
}

variable "db_name" {
  description = "Database name"
  default     = "statamic"
}

variable "db_user" {
  description = "Database username"
  default     = "statamic_user"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "redis_password" {
  description = "Redis password"
  sensitive   = true
}

variable "spaces_bucket" {
  description = "DO Spaces bucket name"
  default     = "statamic-bucket"
}
