#!/usr/bin/python3
'''Get available TRON balance.

Exchange <address> with the address, the available balance should be requested
from.
'''

# Import the Python module.
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

# Set constant SUN.
SUN = 1000000

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Get the response from the given url.
    response = requests.post(URL, json=PAYLOAD, headers=HEADERS)
    # Create a dictionary from the response.
    response = response.json()
    # Get the balance from the dictionary.
    balance = response["balance"] / SUN
    # Print the result to the screen.
    print("Available Balance:", balance, "TRX")

# Execute the script as program as well as module.
if __name__ == "__main__":
    # Call the main script function.
    main()
