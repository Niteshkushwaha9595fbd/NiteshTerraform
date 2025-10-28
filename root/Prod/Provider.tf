terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0" # Or latest you prefer
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "93922b30-ec0c-4cbf-97bc-1f1bc302bde5"
  skip_provider_registration = false
}
