#!/usr/bin/env bash
echo $'\n'Get vars...
oa_token=$(cat init.conf | grep oa_token | sed 's/oa_token = //')
cloud_id=$(cat init.conf | grep cloud_id | sed 's/cloud_id = //')
folder_id=$(cat init.conf | grep folder_id | sed 's/folder_id = //')
service_account=$(cat init.conf | grep service_account | sed 's/service_account = //')

echo $'\n'Set yc...
yc config set token ${oa_token}
serv_acc_id=$(yc iam service-account create ${service_account} --folder-id ${folder_id} | grep ^id: | sed 's/id: //')
yc resource-manager folder add-access-binding default --role="admin" --subject="serviceAccount:${serv_acc_id}"
yc iam key create --service-account-id $serv_acc_id --output key.json 
yc config profile create $service_account
yc config set service-account-key key.json
yc config set cloud-id $cloud_id
yc config set folder-id $folder_id