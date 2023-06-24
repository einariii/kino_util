#! /bin/bash

pnpm install
pnpm build

export LIVEBOOK_TOKEN_ENABLED=false

livebook server ./nbs
