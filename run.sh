#! /bin/bash

docker run \
    --rm \
    -it \
    -v "$PWD":/kino_fly:rw \
    -e LIVEBOOK_HOME=/kino_fly \
    --network host \
    livebook/livebook:latest
