#!/bin/bash

  
  RECORD=$1
  CF_TOKEN="-8shOhBUEV7icCYlMx_n8uTZrGGX6FfyRL2w_lRe"
  ZONE_NAME=$2

  ZONE_ID=$(
            curl -X GET \
                "https://api.cloudflare.com/client/v4/zones?name=${ZONE_NAME}&status=active" \
                -H "Authorization: Bearer ${CF_TOKEN}" \
                -H "Content-Type:application/json" | jq -r '{"result"}[] | .[0] | .id'
  )
  
  RECORD_ID=$(
            curl -X GET \
                https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${RECORD}.${ZONE_NAME} \
                -H 'Content-Type: application/json' \
                -H  "Authorization: Bearer ${CF_TOKEN}" | \
                jq -r '{"result"}[] | .[0] | .id'
    )

  if [[ $RECORD_ID == 'null' ]]; then
      echo ${RECORD} doesn\'t exist!
  else
      echo Deleting $RECORD_ID

      curl -X DELETE 'https://api.cloudflare.com/client/v4/zones/'${ZONE_ID}'/dns_records/'${RECORD_ID} -H 'Authorization: Bearer '${CF_TOKEN} | jq
  fi