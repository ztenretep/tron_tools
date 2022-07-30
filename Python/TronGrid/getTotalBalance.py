#!/usr/bin/python3
'''Get the total TRON balance.

Exchange ADDRESS with the address, the total balance should be requested from.
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
    # Get the response from RPC server.
    response = requests.post(URL, json=PAYLOAD, headers=HEADERS)
    # Create a dictionary from the response.
    response = response.json()
    # Get balance, bandwidth and energy from the dictionary.
    balance = response["balance"] / SUN
    bandwidth = int(response["frozen"][0]["frozen_balance"] / SUN)
    energy = int(response["account_resource"]["frozen_balance_for_energy"]["frozen_balance"] / SUN)
    # Calculate frozen and total balance.
    frozen = bandwidth + energy
    total = balance + frozen
    # Print the total balance to screen.
    print("Total Balance:", total, "TRX")

# Execute script as program or as module.
if __name__ == "__main__":
    # Call the main script function.
    main()
