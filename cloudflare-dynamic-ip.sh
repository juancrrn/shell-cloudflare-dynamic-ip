#!/bin/bash

# Cloudflare dynamic IP address update

# Authentication
TOKEN=
ZONE_ID=

# Common record settings
ZONE_NAME=
RECORD_TYPE=
RULE_PROXIABLE=
RULE_PROXIED=
RULE_LOCKED=
STORED_IP=$(cat cloudflare-dynamic-ip-last.txt)

# Specific record settings
RECORD_ID=
RECORD_NAME=

# Get current public IP address
PUBLIC_IP=$(curl -s 'icanhazip.com')

if [[ $STORED_IP != $PUBLIC_IP ]]
then

    OUTPUT=$(wget --quiet \
        --method PUT \
        --timeout=0 \
        --header 'Content-Type: application/json' \
        --header="Authorization: Bearer $TOKEN" \
        --body-data="{
            \"id\": \"$RECORD_ID\",
            \"type\": \"$RECORD_TYPE\",
            \"name\": \"$RECORD_NAME\",
            \"content\": \"$PUBLIC_IP\",
            \"proxiable\": $RULE_PROXIABLE,
            \"proxied\": $RULE_PROXIED,
            \"ttl\": 1,
            \"locked\": $RULE_LOCKED,
            \"zone_id\": \"$ZONE_ID\",
            \"zone_name\": \"$ZONE_NAME\",
            \"meta\": {
                    \"auto_added\": false,
                    \"managed_by_apps\": false,
                    \"managed_by_argo_tunnel\": false
            }
    }" \
         -O - "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID")

    IP_UPDATED=$(echo $OUTPUT | jq -r '.result.content')
    echo $IP_UPDATED > cloudflare-dynamic-ip-last.txt
    RESULT=$(echo $OUTPUT | jq -r '.success')

    if [[ $RESULT == 'true' ]]
    then
        echo Cloudflare dynamic IP address update success $IP_UPDATED
    else
        echo Cloudflare dynamic IP address udpate error $IP_UPDATED
    fi

fi
