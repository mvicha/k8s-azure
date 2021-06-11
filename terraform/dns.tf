resource "azurerm_private_dns_zone" "k8s_mvilla" {
  name                = "k8smvilla.com"
  resource_group_name = azurerm_resource_group.rg_k8s.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vn_dns_link" {
  name                  = "vn_dns_link"
  resource_group_name   = azurerm_resource_group.rg_k8s.name
  private_dns_zone_name = azurerm_private_dns_zone.k8s_mvilla.name
  virtual_network_id    = azurerm_virtual_network.vn_k8s.id
}


resource "azurerm_private_dns_a_record" "master" {
  name                = "master"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = ["10.17.1.100"]
}

resource "azurerm_private_dns_a_record" "node01" {
  name                = "node01"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = ["10.17.1.101"]
}

resource "azurerm_private_dns_a_record" "node02" {
  name                = "node02"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = ["10.17.1.102"]
}

resource "azurerm_private_dns_cname_record" "nfs" {
  name                = "nfs"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  record              = "master.k8smvilla.com"
}
