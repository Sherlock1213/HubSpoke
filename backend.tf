terraform {
  backend "azurerm" {
    resource_group_name  = "Sherlock"
    storage_account_name = "sherlockholmes12"
    container_name       = "test"
    key                  = "terraform.tfstate"
  }
}