#!/usr/bin/bash

URL="https://api.trongrid.io/walletsolidity/getaccount"

ADDRESS="<address_in_hex>"

PAYLOAD="{ \"address\": \"${ADDRESS}\" }"

curl -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "${PAYLOAD}" "${URL}"

exit 0
