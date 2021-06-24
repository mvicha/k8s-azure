# Creamos una zona de DNS privada para que los nodos se comuniquen entre sí
resource "azurerm_private_dns_zone" "k8s_private_dns_zone" {
  name                = "${var.prefix}.com"
  resource_group_name = azurerm_resource_group.rg_k8s.name
}


# Asociamos la zona de DNS privada a nuestro Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "vn_dns_link" {
  name                  = "vn_dns_link"
  resource_group_name   = azurerm_resource_group.rg_k8s.name
  private_dns_zone_name = azurerm_private_dns_zone.k8s_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vn_k8s.id
}


# Creamos un DNS privado para Master
resource "azurerm_private_dns_a_record" "master" {
  name                = "master"
  zone_name           = azurerm_private_dns_zone.k8s_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = [var.private_lan_master]
}


# Creamos un DNS privado para cada Nodo
resource "azurerm_private_dns_a_record" "node" {
  for_each = var.workers

  name                = lower(each.key)
  zone_name           = azurerm_private_dns_zone.k8s_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  records             = [each.value.ip]
}


# Creamos un DNS alias para Nfs
resource "azurerm_private_dns_cname_record" "nfs" {
  count               = length(var.workers) > 0 ? 1 : 0

  name                = "nfs"
  zone_name           = azurerm_private_dns_zone.k8s_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_k8s.name
  ttl                 = 300
  record              = azurerm_private_dns_a_record.node["Node01"].fqdn
}
