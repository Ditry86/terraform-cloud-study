First, to prepare your storage do the following steps:
1. Put oa_token, cloud_id, foldr_id values from your yandex cloud to [modules/prepare_storage/init.conf file](./modules/prepare_storage/init.conf).
2. In the same folder run init_yc.sh. This scrip will create the folowing objects in your cloud: service account with admin role, environment vatiables for terraform your provider, iam key foe your service account.
3. Then you mast run **terraform init**, **terraform plan**, **terraform apply** to create storage admin account and backet in our yandex object storage.

After in the root project folder run run **terraform init** to set your project terraform backend to remote storage. And give errors ))