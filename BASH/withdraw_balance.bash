#!/usr/bin/bash
# #############################################################################
# Retrieve the list of nodes from the blockchain.
#
# The script is using the command jq for parsing the JSON data.
#
# The URL for a request will be assembled from:
#        Domain：https://api.trongrid.io
# and    Path:   /wallet/withdrawbalance"
#
# The domain remains unchanged, while the path changes with a specific request.
# #############################################################################

# Set the url for the request.
URL="https://api.trongrid.io/wallet/withdrawbalance"

# Set the hex address.
ADDRESS="<public_hex_address>"

# Create the JSON payload for the request.
PAYLOAD="{ \"owner_address\": \"${ADDRESS}\" }"

# The balance is part of the retrieved account data.
response=$(curl -s -d "${PAYLOAD}" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-X POST "${URL}")

# Extract the balance from the JSON data.
withdraw_json=$(echo "${response}" | jq)

# Write JSON data to screen.
echo "${withdraw_json}"

# Exit script without error.
exit 0
