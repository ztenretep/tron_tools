#!/usr/bin/python3
'''Get transaction list from pending.

Get transaction list information from pending pool.

Reference:
https://developers.tron.network/reference/gettransactionlistfrompending
'''

# Import the Python module.
import json
import requests

# Set the service url for the request.
URL = "https://api.trongrid.io/wallet/gettransactionlistfrompending"

# Initialise the headers.
HEADERS = {
    "Accept": "application/json",
}

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Get the response from RPC server.
    response = requests.get(URL, headers=HEADERS)
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
