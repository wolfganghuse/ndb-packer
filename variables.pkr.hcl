variable "nutanix_username" {
  type = string
}

variable "nutanix_password" {
  type =  string
  sensitive = true
}

variable "nutanix_endpoint" {
  type = string
}

variable "nutanix_port" {
  type = number
}

variable "nutanix_insecure" {
  type = bool
  default = true
}

variable "nutanix_subnet" {
  type = string
}

variable "nutanix_cluster" {
  type = string
}

variable "windows_source_uri" {
  type = string
}

variable "virtio_iso_image_name" {
  type = string
}

variable "windows_sql_uri" {
  type = string
}

variable "administrator_username" {
  type = string
}

variable "administrator_password" {
  type = string
}