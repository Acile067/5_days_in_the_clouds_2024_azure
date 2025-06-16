resource azurerm_private_dns_a_record back-a-record {
  name                = azurerm_linux_web_app.backend.name
  zone_name           = azurerm_private_dns_zone.api_zone.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.be-pe.ip_configuration[0].private_ip_address]
}

resource azurerm_private_dns_a_record sql-a-record {
  name                = azurerm_mssql_server.main.name
  zone_name           = azurerm_private_dns_zone.database_zone.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.sql-pe.ip_configuration[0].private_ip_address]
}

resource azurerm_private_dns_a_record st-a-record {
  name                = azurerm_storage_account.main.name
  zone_name           = azurerm_private_dns_zone.storage_zone.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.st-pe.ip_configuration[0].private_ip_address]
}
resource "azurerm_private_dns_a_record" "function-a-record" {
  name                = azurerm_linux_function_app.foo.name  
  zone_name           = azurerm_private_dns_zone.api_zone.name  
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 3600
  records             = [azurerm_private_endpoint.function_pe.ip_configuration[0].private_ip_address]
}