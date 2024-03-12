data "azurerm_subnet" "virtualSubnets1" {
    name                 =  "default24"
    virtual_network_name = "vnet-01"
    resource_group_name  = "cspractice"
    #count                = length(data.azurerm_virtual_network.virtualNetwork1.subnets)
}


output "virtualnetwork_subnets_ids" {
  value = data.azurerm_subnet.virtualSubnets1.*.id
}
