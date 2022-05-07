#!/usr/bin/bash
# #############################################################################
# Retrieve the account information of a Tron address from the blockchain.
#
# The script is using the command jq for parsing the JSON data.
#
# The URL for a request will be assembled from:
#        Domain：https://api.trongrid.io
# and    Path:   /walletsolidity/getaccount
#
# The domain remains unchanged, while the path changes with a specific request.
# #############################################################################

# Set the url for the request.
URL="https://api.trongrid.io/walletsolidity/getaccount"

# Set the Tron address in hex.
ADDRESS="<tron_address_in_hex>"

# Check if the given address is a valid hex number.
if ! (( 16#"${ADDRESS}" )) >/dev/null 2>&1; then
    # Write a message to the screen.
    echo "Hex address is not valid Error!"
    # Exit script with error code 1.
    exit 1
fi

# Create the JSON payload for the request.
PAYLOAD="{ \"address\": \"${ADDRESS}\" }"

# The balance is part of the retrieved account data.
response=$(curl -s -d "${PAYLOAD}" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-X POST "${URL}")

# Extract the balance from the JSON data.
account_info=$(echo "${response}" | jq)

# Write JSON data to screen.
echo "${account_info}"

# Exit script without error.
exit 0
