#!/usr/bin/python3
'''Get node info from the HTTP API.

Description:
The full node TRON HTTP API list can be found on the TRON Developer Hub [1].
The given GetNodeInfo example was adapted for use with the TRON Mainnet.

The request is using the GET method. The output of the response of the
script is given as structured JSON data.

Possible exceptions are not kept at the moment. By calling the signal handler
the script can be terminated by pressing CTRL+C.

Prerequisite:
Install the Python package requests in the latest version from PyPi [2].

Development Software Environment:
  Linux Mint 20.3 (Una)
  Python 3.8.10
  requests 2.28.1
  pylint 2.4.4

References:
[1] https://developers.tron.network/
[2] https://pypi.org/
'''
# pylint: disable=unused-argument

# Import the standard Python module.
import sys
import json
import signal

# Import the PyPi Python module.
import requests

# Set the service url.
URL = "https://api.trongrid.io/wallet/listexchanges"

# Set the request headers.
HEADERS = {"Accept": "application/json"}

# ==============
# Signal handler
# ==============
def handler(signum, frame):
    '''Set up the signal handler.'''
    # Set the message to print.
    msg = "CTRL-C was pressed. The script is terminated."
    # Print the message to the screen.
    print(msg)
    # Exit the script without error.
    sys.exit(0)

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Get the response from the url.
    response = requests.get(URL, headers=HEADERS)
    # Create json data.
    response_json = response.json()
    # Create json string. Using indent of 2 chars.
    response_string = json.dumps(response_json, indent=2)
    # Print json string to screen.
    print(response_string)

# Execute script as program or as module.
if __name__ == "__main__":
    # Register the signal handler.
    signal.signal(signal.SIGINT, handler)
    # Call the main script function.
    main()
