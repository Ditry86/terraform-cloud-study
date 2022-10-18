#!/usr/bin/env bash
echo $'\n'Get vars
oa_token=$(cat init.conf | grep oa_token | sed 's/oa_token = //')
account_id=$(cat init.conf | grep sevice_acc_id | sed 's/sevice_acc_id = //')
cloud_id=$(cat init.conf | grep cloud_id | sed 's/cloud_id = //')
folder_id=$(cat init.conf | grep folder_id | sed 's/folder_id = //')
account=$(cat init.conf | grep account | sed 's/account = //')
zone=$(cat init.conf | grep zone | sed 's/zone = //')

echo $'\n'Set yc
yc config set token $oa_token
yc iam key create --service-account-id $account_id --output key.json 
yc config profile create $account
yc config set service-account-key key.json
yc config set cloud-id $cloud_id
yc config set folder-id $folder_id

echo $'\n'Set env vars
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

echo $'\n'Set terra provider
cat > ~/.terraformrc << _EOF_
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
_EOF_

echo $'\n'Init main.tf
cat > ./main.tf << _EOF_
provider "yandex" {
  zone = "$zone"
}
data "yandex_compute_image" "ubuntu_22" {
  family = "ubuntu-2204-lts"
}
_EOF_

echo $'\n'Init version.tf
cat > ./versions.tf << _EOF_
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
 required_version = ">= 0.13"
}
_EOF_

echo $'\n'Terraform init
terraform init

echo $'\n'Init ssh keys
ssh-keygen -t ed25519 -N $account -f $account'_key'
ssh_key=$(cat  $account'_key.pub')

echo $'\n'Create VM user params
cat > ./inst_meta.conf << _EOF_
#cloud-config
users:
  - name: $account
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - $ssh_key
_EOF_