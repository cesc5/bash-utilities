#!/usr/bin/env bash
# Make calls to a REST API
#
# Usage:
# 

### Header ###
source ./header.sh

### Script ###
PASSWORD=''
BASE_URL=''
TOKEN_URL="${BASE_URL}/token?grant_type=client_credentials"
ENDPOINT_URL="${BASE_URL}/"

TOKEN=$(curl -s --location -w "\n%{http_code}" --request POST "${TOKEN_URL}" \
--header "Authorization: Basic ${PASSWORD}" | {
    read -r body
    read -r code
    if [ "${code}" == "200" ]; then
        jq .access_token -r <<< "$body"
    else
        error "Access token not found, Response code: ${code}. Script aborts with a non 0 exit error."
    fi
} )

debug "Access token: ${TOKEN}"

RESPONSE=$(curl -s --location -w "\n%{http_code}" --request POST "${ENDPOINT_URL}" \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer ${TOKEN}" \
--data-raw '{
    "Patron": "43451735",
    "Mutua": 276
}' | {
    read -r body
    read -r code
    if [ "${code}" == "200" ]; then
        jq . -r <<< "$body"
    else
        error "Access token not found, Response code: ${code}. Script aborts with a non 0 exit error."
    fi
} )

echo "${RESPONSE}" 
exit 0
