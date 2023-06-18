#! /bin/bash

pnpm install
pnpm build

# Issue with loading JS in Docker: Cross-Origin Request Blocked: The Same Origin Policy disallows reading the remote resource at http://0.0.0.0:8081/iframe/v4.html. (Reason: CORS request did not succeed). Status code: (null).
# docker run \
#     --rm \
#     -it \
#     -v "$PWD":/kino:rw \
#     -e LIVEBOOK_HOME=/kino \
#     -e LIVEBOOK_TOKEN_ENABLED=false \
#     -p 8080:8080 \
#     livebook/livebook:latest

livebook server ./nbs
