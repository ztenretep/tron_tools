#!/usr/bin/bash
# #############################################################################
# Retrieve the current block from the blockchain.
#
# The script is using the command jq for parsing the JSON data.
#
# The URL for a request will be assembled from:
#        Domain：https://api.trongrid.io
# and    Path:   /wallet/getnowblock 
#
# The domain remains unchanged, while the path changes with a specific request.
# #############################################################################

# Set the url for the request.
URL="https://api.trongrid.io/wallet/getnowblock"

# The balance is part of the retrieved account data.
response=$(curl -s  \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-X POST "${URL}")

# Extract the balance from the JSON data.
account_info=$(echo "${response}" | jq)

# Write JSON data to screen.
echo "${account_info}"

# Exit script without error.
exit 0
