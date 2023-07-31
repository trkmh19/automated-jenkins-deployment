variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources"
  type        = string
}

variable "location" {
  description = "The location in which to create the resources"
  type        = string
}

variable "admin_username" {
  description = "The username of the VM admin user "
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key used to authenticate the VM admin user"
  type        = string
}
