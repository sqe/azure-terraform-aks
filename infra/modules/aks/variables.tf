variable "environment" {
    type = string
}
variable "location" {
    type = string
}
variable "network_subnet_id" {
    type = string
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}
variable "ssh_key_data" {
    type = string
  
}
variable "appId" {
    type = string
    sensitive = true
}

variable "clientSecret" {
    type = string
    sensitive = true
  
}