include .env
TF_DIR:=./terraform/.terraform

ifndef PROJECT_ID
$(error PROJECT_ID must be set in .env)
endif

.PHONY: init apply destroy qr

$(TF_DIR):
	$(MAKE) init

$(GCP_KEY_PATH):
	$(error Can not find key file in $(GCP_KEY_PATH), GCP_KEY_PATH must be set in .env)

init: $(GCP_KEY_PATH)
	./script/terraform.sh $(GCP_KEY_PATH) \
		init

apply: $(TF_DIR) $(GCP_KEY_PATH)
	./script/terraform.sh $(GCP_KEY_PATH) \
		apply -var project_id=$(PROJECT_ID)

destroy: $(GCP_KEY_PATH)
	./script/terraform.sh $(GCP_KEY_PATH) \
		destroy -var project_id=$(PROJECT_ID)

qr: $(GCP_KEY_PATH)
	./script/show-qr.sh $(GCP_KEY_PATH)