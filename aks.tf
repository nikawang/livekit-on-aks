
# Create the aks cluster.
resource "azurerm_kubernetes_cluster" "aks" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.aks
  dns_prefix          = "${var.aks}-dns"
  kubernetes_version  = var.kubernetes_version
  

  # Set the default node pool config.
  default_node_pool {
    name           = "default"
    node_count      = var.aks-node-count
    vm_size         = var.aks-node-size

    temporary_name_for_rotation = "true"
    max_pods        = 30
    vnet_subnet_id = azurerm_subnet.aks-subnet.id
    
    # kubelet_disk_type  = "Temporary"
    enable_node_public_ip = "true"
    node_network_profile {
      allowed_host_ports {
        port_end = 50000
        port_start = 60000
      }
    }
  }

  
  # Set the identity profile.
  identity {
    type = "SystemAssigned"
  }

  # Set the network profile.
  network_profile {
    network_plugin = "azure"
    network_plugin_mode = "overlay"
    network_data_plane = "cilium"
    pod_cidr = "192.168.0.0/16"
    service_cidr = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
  }


}

output "aks_name" {
    value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  description = "kubeconfig for kubectl access."
  sensitive   = true
}

output "fqdn" {
    value = azurerm_kubernetes_cluster.aks.fqdn
}
