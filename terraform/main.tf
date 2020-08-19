provider "azurerm" {
  version         = "=1.43.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "azuread" {
  version         = "0.7"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

terraform {
  backend "azurerm" {
    container_name = "backend"
  }
}

data "azurerm_client_config" "current" {}
locals {
  managed = "terraform"
  product = "docker-compose-proxy"
  tags = {
    managed = "terraform"
    product = "docker-compose-proxy"
  }
}

resource "azurerm_resource_group" "dcmp" {
  name     = "${local.product}-${var.environment}-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_application_insights" "dcmp" {
  name                = "${local.product}-${var.environment}-ai"
  location            = azurerm_resource_group.dcmp.location
  resource_group_name = azurerm_resource_group.dcmp.name
  retention_in_days   = 90
  application_type    = "web"
  tags                = local.tags
}

resource "azurerm_app_service_plan" "dcmp" {
  name                = "${local.product}-${var.environment}-${lookup(var.location-suffix, var.location, "err")}-asp"
  location            = azurerm_resource_group.dcmp.location
  resource_group_name = azurerm_resource_group.dcmp.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
  tags = local.tags
}

resource "azurerm_app_service" "dcmp-compose" {
  name                = "${local.product}-app-${var.environment}-${lookup(var.location-suffix, var.location, "err")}"
  location            = azurerm_resource_group.dcmp.location
  resource_group_name = azurerm_resource_group.dcmp.name
  app_service_plan_id = azurerm_app_service_plan.dcmp.id

  https_only = true

  site_config {
    always_on        = true
    linux_fx_version = "COMPOSE|${base64encode(replace(file("../docker-compose.yml"), "$${app-hello-tag}", var.app-hello-tag))}"
    scm_type         = "VSTSRM"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.dcmp.instrumentation_key
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${var.acr_domain}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.acr_admin_password
    "HTPASSWD"                        = "admin:$apr1$hxwnkrt3$DfpCSg0fFQ.b1bCkWAqpx1"
  }
  tags = local.tags
}
