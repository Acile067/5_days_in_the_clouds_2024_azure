resource azurerm_public_ip main {
  name                = "pip-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.main.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.main.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.main.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.main.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.main.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.main.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.main.name}-rdrcfg"
  probe_name                     = "${azurerm_virtual_network.main.name}-probe"
}

resource azurerm_application_gateway main {
  name                = "ag-${var.application_name}-${var.environment_name}-${var.location_short}-${var.resource_version}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${azurerm_virtual_network.main.name}-gipcfg"
    subnet_id = azurerm_subnet.snet_app_gateway.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.main.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.probe_name
    host_name             = "${azurerm_linux_web_app.backend.name}.azurewebsites.net"
  }

    probe {
        name                = local.probe_name
        host                = "${azurerm_linux_web_app.backend.name}.azurewebsites.net"
        protocol            = "Http"
        path                = "/players"
        interval            = 30
        timeout             = 30
        unhealthy_threshold = 3
        port                = 80
    
        match {
            status_code = ["200"]
        }
    }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}