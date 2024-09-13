variable "environment" {
    type = string
}
variable "location" {
    type = list(string)
}
variable "network_db_subnet_id" {
    type = string
}

variable "network_vnet_id" {
    type = string
}