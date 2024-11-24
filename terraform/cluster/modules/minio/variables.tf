variable "namespace" {
    type = string
    default = "minio"
}

variable "default_annotations" {
    type = map(string)
    default = {}
}
