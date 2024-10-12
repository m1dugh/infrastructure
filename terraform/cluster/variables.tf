variable "namespaces" {
    type = list(string)
    default = []
}

variable "cloudflare" {
    type = object({
      token = string
    })
}
