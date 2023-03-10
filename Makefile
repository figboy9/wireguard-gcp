include .env
export GCP_KEY_PATH
TF_DIR:=./terraform/.terraform/

ifndef PROJECT_ID
$(error PROJECT_ID must be set in .env)
endif

.PHONY: init apply destroy qr get-conf

$(TF_DIR):
	$(MAKE) init

$(GCP_KEY_PATH):
	$(error Can not find key file in $(GCP_KEY_PATH), GCP_KEY_PATH must be set in .env)

init: $(GCP_KEY_PATH)
	./script/terraform.sh \
		init

apply: $(TF_DIR) $(GCP_KEY_PATH)
	./script/terraform.sh \
		apply -var project_id=$(PROJECT_ID)

destroy: $(GCP_KEY_PATH)
	./script/terraform.sh \
		destroy -var project_id=$(PROJECT_ID)

qr: $(GCP_KEY_PATH)
	./script/show-qr.sh

get-conf: $(GCP_KEY_PATH)
	./script/get-vpn-conf.sh