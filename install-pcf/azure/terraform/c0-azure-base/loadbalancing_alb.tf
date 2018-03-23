///////////////////////////////////////////////
//////// Pivotal Customer[0]       ////////////
////////              ALB          ////////////
///////////////////////////////////////////////

////////////////////////////////
//// Azure Load Balancer Configs
////////////////////////////////

// API&APPS ALB
resource "azurerm_lb" "web" {
  name                = "${var.env_name}-web-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id = "${azurerm_subnet.ert_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.azure_web_lb_ip}"
  }
}

// TCP ALB
resource "azurerm_lb" "tcp" {
  name                = "${var.env_name}-tcp-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id = "${azurerm_subnet.ert_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.azure_tcp_lb_ip}"
  }
}


// SSH-Proxy ALB
resource "azurerm_lb" "ssh-proxy" {
  name                = "${var.env_name}-ssh-proxy-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id = "${azurerm_subnet.ert_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.azure_ssh_proxy_lb_ip}"
  }
}

// DMZ ALB
resource "azurerm_lb" "dmz-web" {
  name                = "${var.env_name}-dmz-web-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id = "${azurerm_subnet.dmz_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.azure_dmz_web_lb_ip}"
  }
}

// DMZ TCP ALB
resource "azurerm_lb" "dmz-tcp" {
  name                = "${var.env_name}-dmz-tcp-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id = "${azurerm_subnet.ert_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.azure_dmz_tcp_lb_ip}"
  }
}

// Internal ALB
resource "azurerm_lb" "internal-web" {
  name                = "${var.env_name}-internal-web-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id = "${azurerm_subnet.internal_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.azure_internal_web_lb_ip}"
  }
}

// Internal TCP ALB
resource "azurerm_lb" "internal-tcp" {
  name                = "${var.env_name}-internal-tcp-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id = "${azurerm_subnet.ert_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.azure_internal_tcp_lb_ip}"
  }
}

////////////////////////////////
//// Backend Pools
////////////////////////////////

// API&APPS
resource "azurerm_lb_backend_address_pool" "web-backend-pool" {
  name                = "web-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
}

// TCP Load Balancer
resource "azurerm_lb_backend_address_pool" "tcp-backend-pool" {
  name                = "tcp-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.tcp.id}"
}

// SSH Proxy
resource "azurerm_lb_backend_address_pool" "ssh-backend-pool" {
  name                = "ssh-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.ssh-proxy.id}"
}

// DMZ
resource "azurerm_lb_backend_address_pool" "dmz-web-backend-pool" {
  name                = "dmz-web-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-web.id}"
}

// DMZ TCP Load Balancer
resource "azurerm_lb_backend_address_pool" "dmz-tcp-backend-pool" {
  name                = "dmz-tcp-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-tcp.id}"
}

// Internal
resource "azurerm_lb_backend_address_pool" "internal-web-backend-pool" {
  name                = "internal-web-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-web.id}"
}

// Internal TCP Load Balancer
resource "azurerm_lb_backend_address_pool" "internal-tcp-backend-pool" {
  name                = "internal-tcp-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-tcp.id}"
}

////////////////////////////////
//// Health Checks
////////////////////////////////

// Go Router HTTPS
resource "azurerm_lb_probe" "web-https-probe" {
  name                = "web-https-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  protocol            = "TCP"
  port                = 443
}


// Go Router HTTP
resource "azurerm_lb_probe" "web-http-probe" {
  name                = "web-http-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  protocol            = "TCP"
  port                = 80
}


// TCP LB 80
resource "azurerm_lb_probe" "tcp-probe" {
  name                = "tcp-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.tcp.id}"
  protocol            = "TCP"
  port                = 80
}

// Diego Brain 2222
resource "azurerm_lb_probe" "ssh-proxy-probe" {
  name                = "ssh-proxy-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.ssh-proxy.id}"
  protocol            = "TCP"
  port                = 2222
}

// Go Router HTTPS - DMZ
resource "azurerm_lb_probe" "dmz-https-probe" {
  name                = "dmz-https-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-web.id}"
  protocol            = "TCP"
  port                = 443
}


// Go Router HTTP - DMZ
resource "azurerm_lb_probe" "dmz-http-probe" {
  name                = "dmz-http-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-web.id}"
  protocol            = "TCP"
  port                = 80
}

// TCP LB 80 - DMZ
resource "azurerm_lb_probe" "dmz-tcp-probe" {
  name                = "dmz-tcp-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-tcp.id}"
  protocol            = "TCP"
  port                = 80
}

// Go Router HTTPS - Internal
resource "azurerm_lb_probe" "internal-https-probe" {
  name                = "internal-https-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-web.id}"
  protocol            = "TCP"
  port                = 443
}


// Go Router HTTP - Internal
resource "azurerm_lb_probe" "internal-http-probe" {
  name                = "internal-http-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-web.id}"
  protocol            = "TCP"
  port                = 80
}

// TCP LB 80 - Internal
resource "azurerm_lb_probe" "internal-tcp-probe" {
  name                = "internal-tcp-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-tcp.id}"
  protocol            = "TCP"
  port                = 80
}

////////////////////////////////
//// Load Balancing Rules
////////////////////////////////


// API&APPS HTTPS
resource "azurerm_lb_rule" "web-https-rule" {
  name                = "web-https-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.web-backend-pool.name}"
  probe_id                = "${azurerm_lb.web.id}/probes/${azurerm_lb_probe.web-https-probe.name}"
}

// API&APPS HTTP
resource "azurerm_lb_rule" "web-http-rule" {
  name                = "web-http-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.web-backend-pool.name}"
  probe_id                = "${azurerm_lb.web.id}/probes/${azurerm_lb_probe.web-http-probe.name}"
}


// TCP LB
resource "azurerm_lb_rule" "tcp-rule" {
  count               = 150
  name                = "tcp-rule-${count.index + 1024}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.tcp.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = "${count.index + 1024}"
  backend_port                   = "${count.index + 1024}"

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.tcp.id}/backendAddressPools/${azurerm_lb_backend_address_pool.tcp-backend-pool.name}"
  probe_id                = "${azurerm_lb.tcp.id}/probes/${azurerm_lb_probe.tcp-probe.name}"
}

// SSH Proxy
resource "azurerm_lb_rule" "ssh-proxy-rule" {
  name                = "ssh-proxy-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.ssh-proxy.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 2222
  backend_port                   = 2222

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.ssh-proxy.id}/backendAddressPools/${azurerm_lb_backend_address_pool.ssh-backend-pool.name}"
  probe_id                = "${azurerm_lb.ssh-proxy.id}/probes/${azurerm_lb_probe.ssh-proxy-probe.name}"
}

// DMZ HTTPS
resource "azurerm_lb_rule" "dmz-https-rule" {
  name                = "dmz-https-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.dmz-web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.dmz-web-backend-pool.name}"
  probe_id                = "${azurerm_lb.dmz-web.id}/probes/${azurerm_lb_probe.dmz-https-probe.name}"
}

// DMZ HTTP
resource "azurerm_lb_rule" "dmz-http-rule" {
  name                = "dmz-http-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.dmz-web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.dmz-web-backend-pool.name}"
  probe_id                = "${azurerm_lb.dmz-web.id}/probes/${azurerm_lb_probe.dmz-http-probe.name}"
}

// DMZ TCP LB
resource "azurerm_lb_rule" "dmz-tcp-rule" {
  count               = 150
  name                = "dmz-tcp-rule-${count.index + 1024}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.dmz-tcp.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = "${count.index + 1024}"
  backend_port                   = "${count.index + 1024}"

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.dmz-tcp.id}/backendAddressPools/${azurerm_lb_backend_address_pool.dmz-tcp-backend-pool.name}"
  probe_id                = "${azurerm_lb.dmz-tcp.id}/probes/${azurerm_lb_probe.dmz-tcp-probe.name}"
}

// Internal HTTPS
resource "azurerm_lb_rule" "internal-https-rule" {
  name                = "internal-https-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.internal-web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.internal-web-backend-pool.name}"
  probe_id                = "${azurerm_lb.internal-web.id}/probes/${azurerm_lb_probe.internal-https-probe.name}"
}

// Internal HTTP
resource "azurerm_lb_rule" "internal-http-rule" {
  name                = "internal-http-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.internal-web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.internal-web-backend-pool.name}"
  probe_id                = "${azurerm_lb.internal-web.id}/probes/${azurerm_lb_probe.internal-http-probe.name}"
}

// Internal TCP LB
resource "azurerm_lb_rule" "internal-tcp-rule" {
  count               = 150
  name                = "internal-tcp-rule-${count.index + 1024}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.internal-tcp.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = "${count.index + 1024}"
  backend_port                   = "${count.index + 1024}"

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.internal-tcp.id}/backendAddressPools/${azurerm_lb_backend_address_pool.internal-tcp-backend-pool.name}"
  probe_id                = "${azurerm_lb.internal-tcp.id}/probes/${azurerm_lb_probe.internal-tcp-probe.name}"
}
