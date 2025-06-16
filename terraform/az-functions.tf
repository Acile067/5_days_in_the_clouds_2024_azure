resource azurerm_user_assigned_identity functions {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "mi-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}-fn"
}

resource azurerm_service_plan functions {
  name                = "asp-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "EP1"
}

resource azurerm_linux_function_app foo {
  name                = "func-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}-foo"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  virtual_network_subnet_id  = azurerm_subnet.snet_functions.id
  service_plan_id            = azurerm_service_plan.functions.id

  site_config {

    application_stack {
      dotnet_version = "8.0"
    }
    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = true
    }
  }

  app_settings = {
    "AzureWebJobsStorage" = azurerm_storage_account.main.primary_connection_string
    "FUNCTIONS_INPROC_NET8_ENABLED" = "1"
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE" = 1
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.functions.id]
  }
}