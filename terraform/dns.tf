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
  records             = [var.private_lan_master]
}


resource "azurerm_private_dns_a_record" "node" {
  for_each = var.workers

  name                = lower(each.key)
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = [each.value.ip]
}


resource "azurerm_private_dns_cname_record" "nfs" {
  name                = "nfs"
  zone_name           = azurerm_private_dns_zone.k8s_mvilla.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  record              = "master.k8smvilla.com"
}
