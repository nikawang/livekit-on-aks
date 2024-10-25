resource "null_resource" "wait_for_kubeconfig" {
  provisioner "local-exec" {
    command =  "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks.name}"
    working_dir = path.module
  }
}

resource "local_file" "kubeconfig" {
  content = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = "${path.module}/kubeconfig"
  depends_on = [null_resource.wait_for_kubeconfig]
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
    kubernetes {
      config_path = local_file.kubeconfig.filename
    }
}


resource "helm_release" "livekit-server" {
    name  = "livekit-server"
    chart = "./helm/charts/livekit-server"
    version = "0.1.0"

    set {
      name = "livekit.redis.address"
      value = "${azurerm_redis_cache.redis[0].hostname}:${azurerm_redis_cache.redis[0].port}"
    }

    set {
        name = "livekit.redis.password"
        value = azurerm_redis_cache.redis[0].primary_access_key
    }

    set {
        name = "livekit.keys.${var.livekit-sever-api-key}"
        value = "${var.livekit-sever-api-secret}"
    }

    depends_on = [ azurerm_redis_cache.redis, module.openai, azurerm_kubernetes_cluster.aks]
}

resource "helm_release" "ingress-nginx" {
    name  = "ingress-nginx"
    chart = "./helm/charts/ingress-nginx"
    version = "0.4.8"

    depends_on = [ azurerm_redis_cache.redis, module.openai, azurerm_kubernetes_cluster.aks]

}


# 创建TLS secret
resource "kubernetes_secret" "tls_secret" {
  metadata {
    name      = "livekit-tls-secret"
    namespace = "default"
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = file("${var.cert-livekit-server}")
    "tls.key" = file("${var.key-livekit-server}")
  }
}

# 创建Ingress资源
resource "kubernetes_ingress_v1" "lksrv_ingress" {
  metadata {
    name      = "lksrv-ingress"
    namespace = "default"
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.host-livekit-server

      http {
        path {
          backend {
            service {
              name = "livekit-server"
              port {
                number = 80
              }
            }
          }

          path     = "/"
          path_type = "Prefix"
        }
      }
    }

    tls {
      hosts = [var.host-livekit-server]
      secret_name = kubernetes_secret.tls_secret.metadata[0].name
    }
  }
}


