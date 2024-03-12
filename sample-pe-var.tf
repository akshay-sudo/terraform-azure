variable "resource_group_name" {
  type=string
  description = "This defines the resource group name"
}
variable "location" {
  type=string
  description = "This defines the location of resource"
}
#variable "subnet_id" {  
#  type        = string  
#  description = "The ID of the subnet where the private endpoint will be deployed."
#  default = ""  
#}  
variable "private_endpoint_name" {  
  type        = string  
  description = "The name of the private endpoint."
  default = "pe-st-aiops-terraform"  
}  
variable "private_dns_zone_name" {  
  type        = string  
  description = "The name of the private DNS zone to create."  
 default = "privatelink.blob.core.windows.net"
}

variable "private_service_connection" {  
  type        = string  
  description = "The name of the private service connection to create."  
 default = "psc-st-aiops-terraform-private-connection"
}
