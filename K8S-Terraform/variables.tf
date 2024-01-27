variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "cluster_name" {
  type    = string
  default = "learn-k8s"
}

variable "k8s_version" {
  type = string
}



variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 2
}

variable "machine_type" {
  type    = string
  default = "t2.small"
}

variable "state_bucket" {
  type    = string
  default = "learn-k8s"
}
