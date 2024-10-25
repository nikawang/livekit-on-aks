resource "kubernetes_deployment" "livekit_agent" {
  depends_on = [ helm_release.livekit-server, module.openai]
metadata {
    name      = "livekit-agent"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "livekit-agent"
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
          app = "livekit-agent"
        }
      }

        spec {
          container {
            image             = "burning1docker/livekit-agent:v1"
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

            env {
              name  = "AZURE_OPENAI_API_KEY"
              value = module.openai.openai_primary_key
            } 
            env {
              name  = "OPENAI_API_KEY"
              value = module.openai.openai_primary_key
            } 
            env {
              name  = "AZURE_OPENAI_ENDPOINT"
              value = module.openai.openai_endpoint
            } 
        }
      }
    }
  }
}
