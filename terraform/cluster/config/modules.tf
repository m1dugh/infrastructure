module "minio" {
    count = var.minio.enable ? 1 : 0
    source = "../modules/minio/"

    default_annotations = local.default_annotations
}
