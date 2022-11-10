terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  cloud {
    organization = "ditry86"
    workspaces {
      name = "prod"
    }
  }
}
 