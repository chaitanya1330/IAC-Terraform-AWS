variable "db_username" {
  type        = string
  description = "Username of the mysql db instance"
  default     = "root"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password of the mysql db instance"
}
