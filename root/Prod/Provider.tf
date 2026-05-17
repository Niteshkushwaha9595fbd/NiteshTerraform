terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "93922b30-ec0c-4cbf-97bc-1f1bc302bde5"
  resource_provider_registrations = "none"
}
