#!/usr/bin/bash
# #############################################################################
# Retrieve the account and the balance information of a Tron address from the
# blockchain.
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

# Create the JSON payload for the request.
PAYLOAD="{ \"address\": \"${ADDRESS}\" }"

# The balance is part of the retrieved account data.
curl -i \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-X POST -d "${PAYLOAD}" "${URL}"

# Exit script without error.
exit 0
