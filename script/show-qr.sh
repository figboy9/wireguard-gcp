#!/bin/sh

ADDRESS=$(
    docker run --rm \
        --name terraform \
        -w /work \
        -v $PWD/terraform:/work \
        -v $GCP_KEY_PATH:/key.json \
        -v $PWD/.ssh:/.ssh \
        hashicorp/terraform \
        output -raw instance_ip_addr
)

ssh -i ./.ssh/ssh_key \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    dev@$ADDRESS \
    docker exec my-wireguard /app/show-peer 1
