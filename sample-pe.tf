resource "random_id" "dns-suffix" {
  byte_length = 1
}

resource "azurerm_storage_account" "appstore" { 
  name                     = "staiopsterraform${random_id.dns-suffix.dec}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  public_network_access_enabled = false
 
}

# Private Endpoint
resource "azurerm_private_dns_zone" "storage_account_dns_zone" {  
  name                = var.private_dns_zone_name  
    resource_group_name = var.resource_group_name
}  
resource "azurerm_private_dns_a_record" "storage_account_dns_record" {  
  name                = azurerm_storage_account.appstore.name  
  zone_name           = azurerm_private_dns_zone.storage_account_dns_zone.name  
  resource_group_name = var.resource_group_name  
  ttl                 = 300  
  records             = [azurerm_storage_account.appstore.primary_blob_endpoint]  
}  
resource "azurerm_private_endpoint" "storage_account_private_endpoint" {  
  name                = var.private_endpoint_name  
  location            = var.location 
  resource_group_name = var.resource_group_name  
  subnet_id           = [data.azurerm_subnet.virtualSubnets1.*.id]  
  private_service_connection {  
    name                           = var.private_service_connection
    private_connection_resource_id = azurerm_storage_account.appstore.id  
    is_manual_connection           = false  
    subresource_names              = ["blob"]  
  }  
  private_dns_zone_group {  
    name         = azurerm_private_dns_zone.storage_account_dns_zone.name  
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_account_dns_zone.id]  
  }  
}  
