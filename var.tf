variable "subscription-id" {
  type = string
  default = "25cc9009-2580-4987-936c-95aaab093023"
}

#virtual network variables
variable "region" {
  type = string
  default = "japaneast"
}

variable "ip-prefix" {
  type = string
  default = "10.199"
}

variable "redis" {
  type = string
  default = "livekit-redis"
}

variable "aks" {
  type = string
  default = "livekit-aks"
}

variable "kubernetes_version" {
  type = string
  default = "1.30"
}

variable "aks-node-count" {
  type = string
  default = "3"
}

variable "aks-node-size" {
  type = string
  default = "Standard_D4ds_v5"
}


variable "livekit-sever-api-key" {
  type        = string
  default     = "my_api_key"
}

variable "livekit-sever-api-secret" {
  type        = string
  default     = "my_api_secret9999999999999999999"
}

variable "host-livekit-server" {
  description = "The host for the ingress livekit-server"
  type        = string
  default     = "livekitsvr.nikadwang.com"
}

variable "host-livekit-playground" {
  description = "The host for the ingress livekit-playground"
  type        = string
  default     = "livekit-pg.nikadwang.com"
}

variable "cert-livekit-playground" {
  type        = string
  default     = "./certs/livekit-playground/fullchain.pem"
}


variable "key-livekit-playground" {
  type        = string
  default     = "./certs/livekit-playground/privkey.pem"
}


variable "cert-livekit-server" {
  type        = string
  default     = "./certs/livekit-server/fullchain.pem"
}


variable "key-livekit-server" {
  type        = string
  default     = "./certs/livekit-server/privkey.pem"
}


