data "yandex_resourcemanager_folder" "default" {
  folder_id = var.yc_folder_id
  name="default"
}

resource "yandex_iam_service_account" "storage_serv_acc" {
  name      = var.storage_account
  folder_id = var.yc_folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "storage_admins" {
  role      = "editor"
  folder_id = "${data.yandex_resourcemanager_folder.default.id}"
  members = [
    "serviceAccount:${yandex_iam_service_account.storage_serv_acc.id}",
  ]
}

resource "yandex_iam_service_account_static_access_key" "stor_serv_acc_key" {
  service_account_id = yandex_iam_service_account.storage_serv_acc.id
}

resource "yandex_storage_bucket" "terraform_backet" {
  access_key = yandex_iam_service_account_static_access_key.stor_serv_acc_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.stor_serv_acc_key.secret_key
  bucket     = var.bucket
}

output "backet" {
  value = yandex_storage_bucket.terraform_backet.bucket
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.stor_serv_acc_key.secret_key
  sensitive = true
}

output "access_key_id" {
  value = yandex_iam_service_account_static_access_key.stor_serv_acc_key.access_key
}
