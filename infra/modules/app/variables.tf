variable "region" {
	description = "The region where the application is deployed"
	type		 = string
}

variable "repository" {
	description = "The repository where the application image is stored"
	type		 = string
}

variable "image_tag" {
	description = "The tag of the application image"
	type		 = string
}

variable "app_env" {
	description = "The environment the application is running in"
	type		 = string
}

variable "app_key" {
	description = "The application key for Statamic"
	type		 = string
}

variable "spaces_key" {
	description = "DigitalOcean Spaces access key"
	type		 = string
}

variable "spaces_secret" {
	description = "The AWS Spaces secret key"
	type		 = string
}

variable "aws_endpoint" {
	description = "The AWS endpoint URL"
	type		 = string
}

variable "app_url" {
	description = "The URL of the application"
	type		 = string
}

variable "app_debug" {
	description = "Enable or disable debug mode"
	type		 = bool
}

variable "log_level" {
	description = "The logging level for the application"
	type		= string
}

variable "session_driver" {
	description = "The session driver for the application"
	type		 = string
}

variable "session_lifetime" {
	description = "The session lifetime for the application"
	type		 = number
}

variable "session_encrypt" {
	description = "Enable or disable session encryption"
	type		 = bool
}
variable "db_connection" {
  description = "The database connection type"
  type		 = string
}
variable "db_host" {
  description = "The database host"
  type		 = string
}
variable "db_port" {
  description = "The database port"
  type		 = number
}
variable "db_name" {
  description = "The database name"
  type		 = string
}
variable "db_user" {
  description = "The database username"
  type		 = string
}
variable "db_password" {
  description = "The database password"
  type		 = string
  sensitive = true
}
