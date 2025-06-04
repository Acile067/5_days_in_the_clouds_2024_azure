resource azurerm_service_plan main {
  name                = "asp-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource azurerm_linux_web_app backend {
  name                = "lwa-${var.application_name}-be-${var.environment_name}-${var.location_short}-${var.resource_version}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    ip_restriction {
      name                      = "Allow-Private-Subnet"
      priority                  = 100
      action                    = "Allow"
      virtual_network_subnet_id = azurerm_subnet.snet_pe.id
    }

    ip_restriction {
      name        = "Deny-All"
      priority    = 200
      action      = "Deny"
      ip_address  = "0.0.0.0/0"
    }

    ip_restriction_default_action = "Deny"
    minimum_tls_version           = "1.2"
    always_on                     = true

    application_stack {
      dotnet_version = "9.0"
    }
  }

  identity {
    type = "SystemAssigned"  
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=sql-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}.database.windows.net,1433;Initial Catalog=sqldb-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version};Persist Security Info=False;User ID=${data.azurerm_key_vault_secret.admin_login.value};Password=${data.azurerm_key_vault_secret.admin_password.value};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  app_settings = {
    
  }
}