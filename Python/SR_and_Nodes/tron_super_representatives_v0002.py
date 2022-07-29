#!/usr/bin/python3
'''Get the list of the TRON Super Representatives.

The network in use is the TRON Mainnet and the related service url is
https://api.trongrid.io for the requests.
'''

# Import the Python modules.
import json
import requests

# Set the service URL.
URL = "https://api.trongrid.io/walletsolidity/listwitnesses"

# ===================
# Function get_list()
# ===================
def get_list():
    '''Get the list of the TRON Super Representatives.'''
    # Set the key.
    key = "witnesses"
    # Get the sr list.
    response = requests.get(URL)
    response_json = response.json()
    sr_list = response_json[key]
    # Return the sr list.
    return sr_list

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Get the sr list.
    sr_list = get_list()
    # Print the sr list to screen.
    print(json.dumps(sr_list, indent=2))

# Execute the script as program or as module.
if __name__ == "__main__":
    # Call the main script function.
    main()
