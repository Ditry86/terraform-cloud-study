#!/usr/bin/env bash

echo $'\n''Get vars...'
storage_account=$(cat init.conf | grep storage_account | sed 's/storage_account = //')

echo $'\n''Init storage admin account...'
stor_serv_acc_id=$(yc iam service-account create ${storage_account} --folder-id ${folder_id} | grep ^id: | sed 's/id: //')
yc resource-manager folder add-access-binding default --role="storage.admin" --subject="serviceAccount:${stor_serv_acc_id}"
yc iam access-key create --service-account-name=${storage_account} >> access.key

echo $'\n''Get storage admin account access key...'
access_key=$(cat access.key | grep key_id: | sed 's/  key_id: //')
secret_key=$(cat access.key | grep secret: | sed 's/secret: //')
sed -i '/access_key/d' init.conf
sed -i '/secret_key/d' init.conf
echo "access_key = ${access_key}" >> init.conf
echo "secret_key = ${secret_key}" >> init.conf
rm access.key