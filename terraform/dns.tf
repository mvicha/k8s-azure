resource "azurerm_private_dns_zone" "k8s_mvilla" {
  name                = "k8s.mvilla"
  resource_group_name = azurerm_resource_group.rg_k8s.name
}

resource "azurerm_dns_a_record" "master" {
  name                = "master"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = ["192.168.1.100"]
}

resource "azurerm_dns_a_record" "node01" {
  name                = "node01"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = ["192.168.1.101"]
}

resource "azurerm_dns_a_record" "node02" {
  name                = "node02"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = ["192.168.1.102"]
}

resource "azurerm_dns_cname_record" "nfs" {
  name                = "nfs"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  record              = "master.k8s.mvilla"
}
