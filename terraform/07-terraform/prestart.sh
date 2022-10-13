#!/usr/bin/env bash



export YC_TOKEN=$(yc iam create-token)
export YC_SERVICE_ACCOUNT_KEY_FILE='key.json'
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

yc config set service-account-key key.json
yc config set cloud-id <идентификатор_облака>
yc config set folder-id <идентификатор_каталога>  