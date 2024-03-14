#Service Plan
resource "azurerm_service_plan" "example" {
  name               = "fa-scratch-functions-tf-silicon999"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name   = "P1v3" 
  os_type    = "Linux"
  
}

# Function App
resource "azurerm_linux_function_app" "example" {
  name                       = "fa-scratch-linuxazure-function-silicon999"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.example.id
  storage_account_name       = azurerm_storage_account.appstore.name
  storage_account_access_key = azurerm_storage_account.appstore.primary_access_key
  https_only                 = true
  depends_on = [ azurerm_storage_account.appstore ]
  app_settings = {
      WEBSITE_RUN_FROM_PACKAGE = "https://silicon999.blob.core.windows.net/func/HttpTrigger1.zip?sp<sastoken>"
      "FUNCTIONS_WORKER_RUNTIME" = "python",
      "AzureWebJobsDisableHomepage" = "true",
      "SCM_DO_BUILD_DURING_DEPLOYMENT" =  "true"
  }
  site_config {
    application_stack {
      python_version = "3.10"
      }
    elastic_instance_minimum = 1
    }
}

# vnet connection
/*
resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id = azurerm_linux_function_app.example.id
  subnet_id           = flatten(data.azurerm_subnet.virtualSubnets1.*.id)[0]
}
*/

#storage account
resource "azurerm_storage_account" "appstore" { 
  name                     = "stcspracticefatf999${random_id.dns-suffix.dec}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  public_network_access_enabled = false
 
}

# Private Endpoint Blob
resource "azurerm_private_endpoint" "storage_account_private_endpoint" {  
  name                = var.private_endpoint_name  
  location            = var.location 
  resource_group_name = var.resource_group_name  
  subnet_id           = flatten(data.azurerm_subnet.virtualSubnets1.*.id)[0]
  private_service_connection {  
    name                           = var.private_service_connection
    private_connection_resource_id = azurerm_storage_account.appstore.id  
    is_manual_connection           = false  
    subresource_names              = ["blob"]  
  }  
}

#Private Endpoint Files  
resource "azurerm_private_endpoint" "storage_account_private_endpoint2" {  
  name                = var.private_endpoint_name2  
  location            = var.location 
  resource_group_name = var.resource_group_name  
  subnet_id           = flatten(data.azurerm_subnet.virtualSubnets1.*.id)[0]
  private_service_connection {  
    name                           = var.private_service_connection2
    private_connection_resource_id = azurerm_storage_account.appstore.id  
    is_manual_connection           = false  
    subresource_names              = ["file"]  
  }  
}  
#Private Endpoint Web 
resource "azurerm_private_endpoint" "storage_account_private_endpoint3" {  
  name                = var.private_endpoint_name3  
  location            = var.location 
  resource_group_name = var.resource_group_name  
  subnet_id           = flatten(data.azurerm_subnet.virtualSubnets1.*.id)[0]
  private_service_connection {  
    name                           = var.private_service_connection3
    private_connection_resource_id = azurerm_storage_account.appstore.id  
    is_manual_connection           = false  
    subresource_names              = ["web"]  
  }  
}  
/*
#Private Endpoint Sites
resource "azurerm_private_endpoint" "storage_account_private_endpoint4" {  
  name                = var.private_endpoint_name4  
  location            = var.location 
  resource_group_name = var.resource_group_name  
  subnet_id           = flatten(data.azurerm_subnet.virtualSubnets1.*.id)[0]
  private_service_connection {  
    name                           = var.private_service_connection4
    private_connection_resource_id = azurerm_storage_account.appstore.id  
    is_manual_connection           = false  
    #subresource_names              = ["sites"]  
    
  }  
} 
*/
#Data

data "azurerm_subnet" "virtualSubnets1" {
    name                 =  "default24"
    virtual_network_name = "vnet-01"
    resource_group_name  = "cspractice"
    #count                = length(data.azurerm_virtual_network.virtualNetwork1.subnets)
}


output "virtualnetwork_subnets_ids" {
  value = data.azurerm_subnet.virtualSubnets1.*.id
}

#Variables
variable "resource_group_name" {
  type=string
  description = "This defines the resource group name"
  default = "cspractice"
}
variable "location" {
  type=string
  description = "This defines the location of resource"
  default = "East US"
}
variable "private_endpoint_name" {  
  type        = string  
  description = "The name of the private endpoint."
  default = "pe-st-fa-terraform999"  
}  

variable "private_service_connection" {  
  type        = string  
  description = "The name of the private service connection to create."  
 default = "psc-st-fa-blob-terraform-private-connection"
}

variable "private_endpoint_name2" {  
  type        = string  
  description = "The name of the private endpoint."
  default = "pe2-st-fa-terraform999"  
}  
variable "private_service_connection2" {  
  type        = string  
  description = "The name of the private service connection to create."  
 default = "psc2-st-fa-file-terraform-private-connection"
}
variable "private_endpoint_name3" {  
  type        = string  
  description = "The name of the private endpoint."
  default = "pe3-st-fa-terraform999"  
}  
variable "private_service_connection3" {  
  type        = string  
  description = "The name of the private service connection to create."  
 default = "psc3-st-fa-web-terraform-private-connection"
}
/*
variable "private_endpoint_name4" {  
  type        = string  
  description = "The name of the private endpoint."
  default = "pe4-st-fa-terraform999"  
}  
variable "private_service_connection4" {  
  type        = string  
  description = "The name of the private service connection to create."  
 default = "psc4-st-fa-sites-terraform-private-connection"
}
*/
