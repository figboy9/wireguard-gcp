#!/bin/sh

docker run --rm \
    --name terraform \
    -it \
    -w /work \
    -v $PWD/terraform:/work \
    -v $1:/key.json \
    -v $PWD/.ssh:/.ssh \
    hashicorp/terraform ${@:2}
