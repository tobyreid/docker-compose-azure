variable "subscription_id" {
    description =  "The target Azure subscription_id"
}
variable "client_id" {
    description =  "The target Azure client_id"
}
variable "client_secret" {
    description =  "The target Azure client_secret"
}
variable "tenant_id" {
    description =  "The target Azure tenant_id"
}

variable "environment" {
    description = "The deployment environment"
    default = "production"
}

variable "location" {
  description = "The Azure Region in which all resources should be created."
  default = "northeurope"
}

variable "location-suffix" {
  type = map

  default = {
    northeurope = "ne"
    westeurope = "we"
    westus = "wus"
    eastus = "eus"
    australiasoutheast = "ase"
  }
}


variable "app-hello-tag" {
  description = "the target front end container version"
  default = "app-hello:latest"
}

variable "api-hello-tag" {
  description = "the target back end container version"
  default = "latest"
}
