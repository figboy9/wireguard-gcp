#!/bin/sh

ADDRESS=$(
    docker run --rm \
        --name terraform \
        -w /work \
        -v $PWD/terraform:/work \
        -v $1:/key.json \
        -v $PWD/.ssh:/.ssh \
        hashicorp/terraform \
        output -raw instance_ip_addr
)

ssh -i ./.ssh/ssh_key \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    dev@$ADDRESS \
    "
    docker cp my-wireguard:/config/peer1/peer1.conf ~ \
    && chmod 400 peer1.conf
    "

scp -i ./.ssh/ssh_key \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    dev@$ADDRESS:~/peer1.conf ./vpn.conf

ssh -i ./.ssh/ssh_key \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    dev@$ADDRESS \
    rm peer1.conf
