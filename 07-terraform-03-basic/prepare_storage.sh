export TF_VAR_stor_serv_acc_id=$(yc iam service-account create --name storage-admin| grep ^id: | sed 's/id: //')
yc resource-manager folder add-access-binding default --role storage.admin --subject serviceAccount:${STOR_SERV_ACC_NAME}
yc iam access-key create --service-account-name ${STOR_SERV_ACC_NAME}
