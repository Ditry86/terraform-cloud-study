terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = data.terraform_remote_state.prepare_storage.output.backet
    key        = "07-terraform/03-base.tfstate"
    access_key = data.terraform_remote_state.prepare_storage.output.access_key
    secret_key = data.terraform_remote_state.prepare_storage.output.secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

data "terraform_remote_state" "prepare_storage" {
  backend = "local"

  config = {
    path = "./modules/prepare_storage/terraform.tfstate"
  }
}