#!/usr/bin/python3
'''Get TRON account overview.

Exchange ADDRESS with the address, the account info should requested from.
'''

# Import the Python module.
import json
import requests

# Set address (public key).
ADDRESS = "<address>"

# Set the URL for the request.
URL = "https://api.trongrid.io/walletsolidity/getaccount"

# Initialise the payload.
PAYLOAD = {"address": ADDRESS, "visible": "True"}

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
