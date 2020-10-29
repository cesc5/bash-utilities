#!/usr/bin/env bash
# Check SOAP API Calls
#
# Usage: 
#  Create a .password with the TOKEN password
#  Create a payload.xml with the curl payload
# 
# Return:
#  0 => curl failed
#  1 => curl OK

### Header ###
source ./header.sh

### Script ###
PASSWORD=''
BASE_URL=''
TOKE_AUTH=''
TOKEN_URL="${BASE_URL}/token?"
ENDPOINT_URL="${BASE_URL}/services/v1.0.0"

TOKEN=$(curl -s --location -w "\n%{http_code}" --request POST "${TOKEN_URL}" \
--header "Authorization: Basic ${TOKE_AUTH}" | {
    read -r body
    read -r code
    if [ "${code}" == "200" ]; then
        jq .access_token -r <<< "$body"
    else
        error "Access token not found, Response code: ${code}. Script aborts with a non 0 exit error."
        debug "$body"
        exit 1
    fi
} )

debug "Access token: ${TOKEN}"

RESPONSE=$(curl -s --location -w "|%{http_code}" --request POST "${ENDPOINT_URL}" \
--header 'Content-Type: text/xml' \
--header "Authorization: Bearer ${TOKEN}" \
--data @payload.xml | {
    read -r -d '|' body
    read -r code
    if [ "${code}" == "200" ]; then
      echo "$body"
    else
      debug "Response code: ${code}."
      debug "$body"
      echo 0
      exit 0
    fi
} )

echo "${RESPONSE}" | grep '<c>end</c>' -c
exit 0
