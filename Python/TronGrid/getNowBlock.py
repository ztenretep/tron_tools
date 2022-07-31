#!/usr/bin/python3
'''Get current block.'''

# Import the Python modules.
import requests
import json

# Set the service url.
#URL = "https://api.trongrid.io/wallet/getnowblock"
URL = "https://api.trongrid.io/walletsolidity/getnowblock"

# Set the headers.
HEADERS = {"Accept": "application/json"}

# Get the response.
response = requests.post(URL, headers=HEADERS)

# Get json dictionary from the response.
response_json = response.json()

# Get json data from the dictionary.
response_data = json.dumps(response_json, indent=2)

# Print result to screen.
print(response_data)
