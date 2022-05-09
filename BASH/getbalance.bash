#!/usr/bin/bash
# #############################################################################
# Retrieve the account and the balance information of a Tron address from the
# blockchain. Outputs the balance.
#
# The script is using the command jq for parsing the JSON data.
#
# The URL for a request will be assembled from:
#        Domain：https://api.trongrid.io
# and    Path:   /walletsolidity/getaccount
#
# The domain remains unchanged, while the path changes with a specific request.
#
# The Base58 decoder is adopted from an previous version of the Bitcoin tools
# of grondilu/bitcoin-bash-tools. 
# #############################################################################

# Set the url for the request.
URL="https://api.trongrid.io/walletsolidity/getaccount"

# Set the variable SUN.
SUN="1000000"

# Set the Tron address in base58 or in hex.
#ADDRESS="<tron_address_in_hex>"
#ADDRESS="<tron_address_in_base58>"
ADDRESS="<tron_address>"

# Declare the array with the Base58 characters.
declare -a base58_chars=(
    1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h i j k   m n o p q r s t u v w x y z
)

# Declare the Base58 mapping string.
map=""
for chr in {0..57}; do
    map+="${chr}s${base58_chars[chr]}"
done

# =======================
# Function decodeBase58()
# =======================
function decodeBase58() {
    decoded_Base58=$(echo -n "$1" |
    sed -e 's/^\(1*\).*/\1/' -e 's/1/00/g'
    dc -e "${map} 16o0$(sed 's/./ 58*l&+/g' <<< $1)p" |
    while read n; do echo -n "${n/\\/}"; done)
    echo "${decoded_Base58:0:42}"
}

# Check if the given address is a hex address.
if ! (( 16#"${ADDRESS}" )) >/dev/null 2>&1; then
    ADDRESS=$(decodeBase58 "${ADDRESS}")
fi

# Create the JSON payload for the request.
PAYLOAD="{ \"address\": \"${ADDRESS}\" }"

# The balance is part of the retrieved account data.
response=$(curl -s -d "${PAYLOAD}" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-X POST "${URL}")

# Extract the balance from the JSON data.
balance=$(echo "${response}" | jq .balance)

# Calculate the balance as decimal.
echo $(bc <<< "scale=6; (${balance}/${SUN})")

# Exit script without error.
exit 0
