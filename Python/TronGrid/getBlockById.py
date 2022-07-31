#!/usr/bin/python3
'''Get block by id.
'''

# Import the Python module.
import json
import requests

# Set block number.
BLOCK_ID = "00000000000000c82a54a3bbdc956e1ddebc903f29b8daf28505b56f55a3f87d"

# Set the service url.
#URL = "https://api.trongrid.io/wallet/getblockbyid"
URL = "https://api.trongrid.io/walletsolidity/getblockbyid"

# Set payload.
PAYLOAD = {"value": BLOCK_ID}

# Initialise the headers.
HEADERS = {
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Get the response from RPC server.
    response = requests.post(URL, json=PAYLOAD, headers=HEADERS)
    # Create adictionary from the response.
    response = response.json()
    # Create json data from dictionary.
    response_json = json.dumps(response, indent=2)
    # Print result to screen.
    print(response_json)

# Execute script as program or as module.
if __name__ == "__main__":
    # Call the main script function.
    main()
