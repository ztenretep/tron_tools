#!/usr/bin/bash
# #############################################################################
# Retrieve the list of nodes from the blockchain.
#
# The script is using the command jq for parsing the JSON data.
#
# The URL for a request will be assembled from:
#        Domain：https://api.trongrid.io
# and    Path:   /wallet/broadcasttransaction
#
# The domain remains unchanged, while the path changes with a specific request.
# #############################################################################

# Set URL.
URL="https://api.trongrid.io/wallet/broadcasttransaction"

# Set constants.
raw_data="<raw_data_from_transaction>"
raw_data="<raw_data_hex_from_transaction>"
signature="<signature_from_external_signer>"

# Set the payload.
PAYLOAD="{ \"raw_data\": {"${raw_data}" }, \"raw_data_hex\": \""${raw_data_hex}"\", \"signature\": [ \""${signature}"\" ] }"

# Get response from api.
response_bc=$(curl -s -d "${PAYLOAD}" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-X POST "${URL}")

# Extract the balance from the JSON data.
response_json=$(echo "${response_bc}" | jq)

# Write JSON data to screen.
echo "${response_json}"

# Exit script without error.
exit 0
