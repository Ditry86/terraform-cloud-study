terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-07-bucket"
    region     = "ru-central1-a"
    workspace_key_prefix = "07-terraform-03"
    key        = "main.tfstate"
    access_key = "YCAJEfYypNp-SXjEheTKbK6sk"
    secret_key = "YCMVRUQKOxqAAH9nb-STvJMpXyR0GDgswqBz7FJZ"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

data "yandex_compute_image" "ubuntu_22" {
  family = "ubuntu-2204-lts"
}
