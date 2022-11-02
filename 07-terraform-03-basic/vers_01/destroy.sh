terraform destroy --input=false
yc iam service-account delete $(cat init.conf | grep service_account | sed 's/service_account = //')
yc iam service-account delete $(cat init.conf | grep storage_account | sed 's/storage_account = //')
yc config profile activate default && yc config profile delete $(cat init.conf | grep service_account | sed 's/service_account = //')
rm -rf terraform/.terraform*
rm terraform/main.tf
unset "${!YC@}"
echo $'\n'I did it$'\n'