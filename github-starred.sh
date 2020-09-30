#!/bin/bash

USER=cesc5
PAGES=5

for PAGE in $(seq ${PAGES}); do
    curl -sH "Accept: application/vnd.github.v3.star+json" \
    "https://api.github.com/users/$USER/starred?per_page=100&page=$PAGE" |
    jq -r '.[]|[.starred_at,.repo.full_name, .description]|@tsv'
done
