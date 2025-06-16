resource azurerm_private_dns_zone api_zone {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource azurerm_private_dns_zone_virtual_network_link api_link {
  name                  = "api-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.api_zone.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource azurerm_private_dns_zone database_zone {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource azurerm_private_dns_zone_virtual_network_link database_link {
  name                  = "database-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.database_zone.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

resource azurerm_private_dns_zone storage_zone {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource azurerm_private_dns_zone_virtual_network_link storage_link {
  name                  = "storage-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_zone.name
  virtual_network_id    = azurerm_virtual_network.main.id
}