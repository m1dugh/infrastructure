variable "namespaces" {
  type    = list(string)
  default = []
}

variable "cloudflare" {
  type = object({
    token = string
  })
}

variable "metrics_server" {
  type = object({
    enable = optional(bool, false)
  })
  default = {}
}

variable "ingresses" {
  type = object({
    enable = optional(bool, false)
  })
  default = {}
}

variable "cert_manager" {
  type = object({
    enable = optional(bool, false)
  })
  default = {}
}

variable "monitoring" {
  type = object({
    enable = optional(bool, false)
  })
  default = {}
}

variable "nfs_provisioner" {
  type = object({
    enable = optional(bool, false)
  })
  default = {}
}
