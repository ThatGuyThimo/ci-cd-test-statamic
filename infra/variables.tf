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

variable "db_connection" {
  description = "The database connection type"
  type        = string
  default     = "mysql"
}

variable "db_host" {
  description = "The database host"
  type        = string
  default     = "localhost"
}

variable "db_port" {
  description = "The database port"
  type        = number
  default     = 3306
}

variable "redis_password" {
  description = "Redis password"
  sensitive   = true
}

variable "spaces_bucket" {
  description = "DO Spaces bucket name"
  default     = "statamic-bucket-three"
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

variable "app_url" {
  description = "the url the app expects to be hosted on"
  type        = string
  default     = "https://localhost"
  sensitive   = false
}

variable "asset_url" {
  description = "The URL for serving assets"
  type        = string
  default     = "https://localhost"
  # this NEEDS to be set to the right url when deployed in Digital Ocean
}

variable "app_debug" {
  description = "Enable or disable debug mode"
  type        = bool
  default     = false
}

variable "log_level" {
  description = "The logging level for the application"
  type        = string
  default     = "debug"
}

variable "session_driver" {
  description = "The session driver for the application"
  type        = string
  default     = "file"
}

variable "session_lifetime" {
  description = "The session lifetime for the application"
  type        = number
  default     = 120
}

variable "session_encrypt" {
  description = "Enable or disable session encryption"
  type        = bool
  default     = false
}