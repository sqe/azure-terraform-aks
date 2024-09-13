variable "ARM_SUBSCRIPTION_ID" {
  default = ""
  type    = string
}

variable "environment" {
  type = string
}
variable "location" {
  type = list(string)
}

variable "appId" {
    type = string
    sensitive = true
}

variable "clientSecret" {
    type = string
    sensitive = true
  
}