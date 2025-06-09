# Specify all providers I will need
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
}

# Configure the AzureRM provider
provider "azurerm" {
  features {}
  alias                           = "demo"
  tenant_id                       = var.entra_tenant_id
  subscription_id                 = var.az_sub_id
  resource_provider_registrations = "none"
}

# Configure the AzureAPI provider
provider "azapi" {
  alias           = "demo"
  tenant_id       = var.entra_tenant_id
  subscription_id = var.az_sub_id
}

# For some reason, this syntax doesn't work well in variables.tf 
# when using TF_VAR_ environment variables -- it has to go here in this file.
# OK to put it at the bottom; it will be hoisted.
variable "entra_tenant_id" {
  type = string
}
variable "az_sub_id" {
  type = string
}
variable "workload_nickname" {
  type = string
}
