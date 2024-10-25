resource "kubernetes_deployment" "livekit_playground" {
  metadata {
    name      = "livekit-playground"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "livekit-playground"
      }
    }
    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
    }

    template {
      metadata {
        labels = {
          app = "livekit-playground"
        }
      }

      spec {
        container {
          image             = "burning1docker/livekit-playground:v1"
          image_pull_policy = "Always"
          name              = "app"

          port {
            container_port = 3000
          }

          env {
            name  = "LIVEKIT_URL"
            value = "https://${var.host-livekit-server}"
          }

          env {
            name  = "LIVEKIT_API_KEY"
            value = var.livekit-sever-api-key
          }

          env {
            name  = "LIVEKIT_API_SECRET"
            value = var.livekit-sever-api-secret
          }
        }
      }
    }
  }
  depends_on = [ helm_release.livekit-server, module.openai]
}


resource "kubernetes_service" "livekit_playground_service" {
  metadata {
    name      = "livekit-playground-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = kubernetes_deployment.livekit_playground.spec.0.template.0.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_secret" "lkpg_tls_secret" {
  metadata {
    name      = "livekit-pg-tls-secret"
    namespace = "default"
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = file("${var.cert-livekit-playground}")
    "tls.key" = file("${var.key-livekit-playground}")
  }
}

# 创建Ingress资源
resource "kubernetes_ingress_v1" "lkplayground_ingress" {
  metadata {
    name      = "lkplayground-ingress"
    namespace = "default"
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.host-livekit-playground

      http {
        path {
          backend {
            service {
              name = "livekit-playground-service"
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
      hosts = [var.host-livekit-playground]
      secret_name = kubernetes_secret.lkpg_tls_secret.metadata[0].name
    }
  }
}
