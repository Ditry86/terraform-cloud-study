export TF_VAR_token=$(yc iam create-token)
export TF_VAR_cloud_id=$(yc config get cloud-id)
export TF_VAR_folder_id=$(yc config get folder-id)
export TF_VAR_zone=$(cat init.conf | grep zone | sed 's/zone = //')
export TF_VAR_bucket=$(cat init.conf | grep bucket | sed 's/bucket = //')
export TF_VAR_access_key=$(cat init.conf | grep access_key | sed 's/access_key = //')
export TF_VAR_secret_key=$(cat init.conf | grep secret_key | sed 's/secret_key = //')