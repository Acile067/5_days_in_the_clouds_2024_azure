resource azurerm_private_endpoint be-pe {
  name                = "pe-${var.application_name}-be-${var.environment_name}-${var.location_short}-${var.resource_version}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.snet_pe.id

  private_service_connection {
    name                           = "psc-${var.application_name}-be-${var.environment_name}-${var.location_short}-${var.resource_version}"
    private_connection_resource_id = azurerm_linux_web_app.backend.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  ip_configuration {
    private_ip_address = "10.0.4.189"
    subresource_name   = "sites"
    member_name        = "sites"
    name               = "be-priv-ep"
  }
}

resource azurerm_private_endpoint sql-pe {
  name                = "pe-${var.application_name}-sql-${var.environment_name}-${var.location_short}-${var.resource_version}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.snet_pe.id

  private_service_connection {
    name                           = "psc-${var.application_name}-sql-${var.environment_name}-${var.location_short}-${var.resource_version}"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  ip_configuration {
    private_ip_address = "10.0.4.185"
    subresource_name   = "sqlServer"
    member_name        = "sqlServer"
    name               = "sql-priv-ep"
  }
}