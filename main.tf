provider "yandex" {
  token                    = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "ubuntu_22" {
  family = "ubuntu-2204-lts"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    endpoint   = "storage.yandexcloud.net"
    bucket     = var.bucket
    region     = var.zone
    key        = "07-terraform-03/prod/main.tfstate"
    access_key = var.access_key
    secret_key = var.secret_key
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}