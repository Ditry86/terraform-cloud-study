#!/usr/bin/env bash
echo $'\n'Get vars
oa_token=$(cat init.conf | grep oa_token | sed 's/oa_token = //')
cloud_id=$(cat init.conf | grep cloud_id | sed 's/cloud_id = //')
folder_id=$(cat init.conf | grep folder_id | sed 's/folder_id = //')
account=$(cat init.conf | grep account | sed 's/account = //')
zone=$(cat init.conf | grep zone | sed 's/zone = //')
storage_account=$(cat init.conf | grep storage_account | sed 's/storage_account = //')
backet=$(cat init.conf | grep backet | sed 's/backet = //')

echo $'\n'Set yc
yc config set token ${oa_token}
serv_acc_id=$(yc iam service-account create --name ${account} --folder-name=default | grep ^id: | sed 's/id: //')
yc iam key create --service-account-id ${serv_acc_id} --output key.json 
yc config profile create ${account}
yc config set service-account-key key.json
yc config set cloud-id ${cloud_id}
yc config set folder-id ${folder_id}

echo $'\n'Set env vars
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=${cloud_id}
export YC_FOLDER_ID=${folder_id}

export TF_VAR_stor_serv_acc_id=$(yc iam service-account create --name ${storage_account} --folder-name=default | grep ^id: | sed 's/id: //')
yc resource-manager folder add-access-binding default --role storage.admin --subject serviceAccount:${TF_VAR_stor_serv_acc_id}
yc iam access-key create --service-account-name ${storage_account} >> access.key
export TF_VAR_access_key=$(cat access.key | grep key_id: | sed 's/key_id: //')
export TF_VAR_secret_key=$(cat access.key | grep secret: | sed 's/secret: //')


