#!/usr/bin/env bash
terraform destroy -auto-approve
yc iam service-account delete --name $(cat init.conf | grep storage_account | sed 's/storage_account = //')
yc config profile activate default && yc config profile delete $(cat init.conf | grep service_account | sed 's/service_account = //')
yc iam service-account delete --name $(cat init.conf | grep service_account | sed 's/service_account = //')

rm -rf terraform/.terraform*
rm -rf terraform/terraform*
rm terraform.tfstate
rm terraform/main.tf
rm key.json
unset "${!YC@}"
echo $'\n'I did it$'\n'