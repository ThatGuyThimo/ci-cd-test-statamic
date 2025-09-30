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

variable "app_repository" {
    description = "App repositroy from DigitalOcean"
    type        = string
}

variable "region" {
  description = "DO region"
  default     = "ams3"
}

variable "cluster_name" {
  description = "Database cluster name"
  default     = "statamic-mysql"
}

variable "cluster_size" {
  description = "Database cluster size"
  default     = "db-s-1vcpu-1gb"
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

variable "spaces_key" {
  description = "DigitalOcean Spaces access key"
  type        = string
  sensitive   = true
}

variable "spaces_secret" {
  description = "DigitalOcean Spaces secret key"
  type        = string
  sensitive   = true
}
