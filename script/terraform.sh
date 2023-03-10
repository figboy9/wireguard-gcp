#!/bin/sh

docker run --rm \
    --name terraform \
    -it \
    -w /work \
    -v $PWD/terraform:/work \
    -v $GCP_KEY_PATH:/key.json \
    -v $PWD/.ssh:/.ssh \
    hashicorp/terraform $@
