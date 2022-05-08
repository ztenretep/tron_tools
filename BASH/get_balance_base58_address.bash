#!/usr/bin/bash
# #############################################################################
# Retrieve the account and the balance information of a Tron address from the
# blockchain. Outputs the balance.
#
# The script is using the command jq for parsing the JSON data.
#
# The keyword visible controls how the private key is use:
#     Value: true ->  Base58 address
#     Value: false -> Hex address
#
# The URL for a request will be assembled from:
#        Domain：https://api.trongrid.io
# and    Path:   /walletsolidity/getaccount
#
# Script was tested on:
#    Linux Ubuntu 20.04
#    Gnu Bash 5.0
#
# The domain remains unchanged, while the path changes with a specific request.
# #############################################################################

# Set the constant.
SHOW_ADDRESS=false
SHOW_PAYLOAD=false
SHOW_TRON=false

# Get the command line arguments.
while getopts acp opt 1>&2 2>/dev/null
do
    case "${opt}" in
        a) SHOW_ADDRESS=true;;
        c) SHOW_TRON=true;;
        p) SHOW_PAYLOAD=true;;
        ?) echo "ERROR: Unknown command line argument ${OPTIND} encountered.";;
    esac
done

# Set the URL for the request.
URL="https://api.trongrid.io/walletsolidity/getaccount"

# Set the variable SUN.
SUN="1000000"

# Set the Tron address in hex.
ADDRESS="<tron_address_in_base58>"

# Create the JSON payload for the request.
PAYLOAD="{ \"address\": \"${ADDRESS}\", \"visible\": \"True\" }"

# Show payload if flag is set to true.
if "${SHOW_ADDRESS}" ; then
    echo "TRON Base58 address: ${ADDRESS}"
fi

# Show payload if flag is set to true.
if "${SHOW_PAYLOAD}" ; then
    echo "${PAYLOAD}" | jq
fi

# The balance is part of the retrieved account data.
response=$(curl -s -d "${PAYLOAD}" \
           -H "Accept: application/json" \
           -H "Content-Type: application/json" \
           -X POST "${URL}")

# Extract the balance from the JSON data.
balance=$(echo "${response}" | jq .balance)

# Calculate the balance as decimal.
balance=$(bc <<< "scale=6; (${balance}/${SUN})")

# Print with or without currency.
if "${SHOW_TRON}" == true; then
    echo "${balance} TRX"
else
    echo "${balance}"
fi

# Exit script without error.
exit 0
