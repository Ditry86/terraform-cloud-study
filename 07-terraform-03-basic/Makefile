SHELL:=/usr/bin/env bash
prepare: cloud init workspace

start_prod: prod plan apply

start_stage: stage plan apply

deploy: plan apply

cloud:
	source ./init_cloud.sh

env:
	source ./reinit_env.sh

init:
	source ./reinit_env.sh && source ./init_terraform.sh

prod:
	cd ./terraform && terraform workspace select prod

stage:
	cd ./terraform && terraform workspace select stage

workspace:
	cd ./terraform && terraform workspace new prod && terraform workspace new stage

plan: 
	source ./reinit_env.sh && cd ./terraform && terraform plan -out=terraform.tfplan

apply: 
	source ./reinit_env.sh && cd ./terraform && terraform apply -auto-approve

destroy: 
	source ./reinit_env.sh && source ./destroy.sh