#!/usr/bin/bash

# Set API url.
URL="https://api.trongrid.io/walletsolidity/getaccount"

# Set Tron address in hex.
ADDRESS="<tron_address_in_hex>"

# Create payload.
PAYLOAD="{ \"address\": \"${ADDRESS}\" }"

# Request account data.
curl -i \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-X POST -d "${PAYLOAD}" "${URL}"

# Exit script without error.
exit 0
