

terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = yandex_storage_bucket.terraform_backet.bucket
    region     = "${var.yc_zone}"
    key        = "07-terraform/03-base.tfstate"
    access_key = "${yandex_iam_service_account_static_access_key.stor_serv_acc_key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.stor_serv_acc_key.secret_key}"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}


provider "yandex" {
  zone = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu_22" {
  family = "ubuntu-2204-lts"
}

resource "yandex_iam_service_account" "storage_serv_acc" {
  name        = "storage-admin"
  folder_id   = var.yc_folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "storage_admins" {
  folder_id   = "${yandex_iam_service_account.storage_serv_acc.folder_id}"
  role        = "storage.admin"
  members     = [
    "serviceAccount:${yandex_iam_service_account.storage_serv_acc.id}",
  ]
}

resource "yandex_iam_service_account_static_access_key" "stor_serv_acc_key" {
  service_account_id = "${yandex_iam_service_account.storage_serv_acc.id}"
  description        = "this key is for my storage service accaunt"
}

resource "yandex_storage_bucket" "terraform_backet" {
  access_key = "${yandex_iam_service_account_static_access_key.stor_serv_acc_key.access_key}"
  secret_key = "${yandex_iam_service_account_static_access_key.stor_serv_acc_key.secret_key}"
  bucket     = "terraform-states-backet"
}



output "secret_key" {
  value="${yandex_iam_service_account_static_access_key.stor_serv_acc_key.secret_key}"
  sensitive = true
}

output "access_key_id" {
  value="${yandex_iam_service_account_static_access_key.stor_serv_acc_key.access_key}"
}
