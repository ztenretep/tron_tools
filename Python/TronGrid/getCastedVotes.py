#!/usr/bin/python3
'''Get the TRON votes.

Exchange ADDRESS with the address, the votes should be requested from.
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
    # Create dictionary from the response.
    response = response.json()
    # Get the number of votes from the dictionary.
    votes = response["votes"]
    votes_sum = sum([v["vote_count"] for v in votes])
    # print the result to the screen.
    print("Casted Votes:", votes_sum)

# Execute script as program or as module.
if __name__ == "__main__":
    # Call the main script function.
    main()
