provider "azurerm" {
    version = "=1.43.0"
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
}

provider "azuread" {
    version = "0.7"
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

data "azurerm_client_config" "current" { }
locals {
    managed = "terraform"
    product = "docker-compose-proxy"
    tags = {
        managed = "terraform"
        product = "docker-compose-proxy"
    }
}

resource "azurerm_resource_group" "dcmp" {
        name = "${local.product}-${var.environment}-rg"
        location = var.location
        tags = local.tags
}

resource "azurerm_application_insights" "dcmp" {
  name                = "${local.product}-${var.environment}-ai"
  location            = azurerm_resource_group.dcmp.location
  resource_group_name = azurerm_resource_group.dcmp.name
  retention_in_days   = 90
  application_type    = "web"
  tags = local.tags
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

resource "azurerm_container_registry" "dcmp" {
  name                     = "dcmpacr"
  resource_group_name      = azurerm_resource_group.dcmp.name
  location                 = azurerm_resource_group.dcmp.location
  sku                      = "Basic"
  admin_enabled            = true
}

resource "azurerm_app_service" "dcmp-compose" {
  name                = "${local.product}-app-${var.environment}-${lookup(var.location-suffix, var.location, "err")}"
  location            = azurerm_resource_group.dcmp.location
  resource_group_name = azurerm_resource_group.dcmp.name
  app_service_plan_id = azurerm_app_service_plan.dcmp.id

  https_only          = true

  site_config {
    always_on         = true
    linux_fx_version  = "COMPOSE|${filebase64("../docker-compose.yml")}"
    scm_type          = "VSTSRM"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.dcmp.instrumentation_key
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.dcmp.admin_password
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.dcmp.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.dcmp.admin_username
  }
  tags = local.tags
}
