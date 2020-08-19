variable "subscription_id" {
  description = "The target Azure subscription_id"
}
variable "client_id" {
  description = "The target Azure client_id"
}
variable "client_secret" {
  description = "The target Azure client_secret"
}
variable "tenant_id" {
  description = "The target Azure tenant_id"
}

variable "environment" {
  description = "The deployment environment"
  default     = "master"
}

variable "location" {
  description = "The Azure Region in which all resources should be created."
  default     = "northeurope"
}

variable "location-suffix" {
  type = map

  default = {
    northeurope        = "ne"
    westeurope         = "we"
    westus             = "wus"
    eastus             = "eus"
    australiasoutheast = "ase"
  }
}


variable "app_hello_tag" {
  description = "the target front end container version"
}

variable "acr_domain" {
  description = "the domain of the Azure Container Registry"
}
variable "acr_admin_username" {
}
variable "acr_admin_password" {
}

variable "product_name" {
  description = "The product prefix used to construct the azure resources"
}