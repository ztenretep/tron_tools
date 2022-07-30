#!/usr/bin/python3
'''Tron account overview.

Exchange ADDRESS with the address, the balance should requested from.
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

# Set the format string.
FMT_STR = "{0:<15s} {1}"

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Get the response from RPC server.
    response = requests.post(URL, json=PAYLOAD, headers=HEADERS)
    # Create dictionary from the response.
    response = response.json()
    # Get balance, bandwidth and energy from the dictionary.
    balance = response["balance"] / SUN
    bandwidth = int(response["frozen"][0]["frozen_balance"] / SUN)
    energy = int(response["account_resource"]["frozen_balance_for_energy"]["frozen_balance"] / SUN)
    # Get the number of votes from the dictionary.
    votes = response["votes"]
    votes_sum = sum([v["vote_count"] for v in votes])
    # Calculate frozen and total value.
    frozen = bandwidth + energy
    total = balance + frozen
    # Create the result dictionary.
    msg_dict = {"Total balance:": str(total),
                "Free balance:": str(balance),
                "Frozen balance:": str(frozen),
                "Voted balance:": str(votes_sum)}
    # Loop over the dictionary.
    for key, value in msg_dict.items():
        # Print result to screen.
        print(FMT_STR.format(key, value))

# Execute script as program or as module.
if __name__ == "__main__":
    # Call the main script function.
    main()
