#!/usr/bin/python3
"""Sign transaction."""
# pylint: disable=invalid-name
# pylint: disable=no-value-for-parameter

# Import the Python modules.
import sys
from eth_account import Account

# Read the commandline arguments.
txID = sys.argv[2]
privKey = sys.argv[1]

# Sign the transaction ID hash.
sign_tx = Account.signHash(txID, privKey)
sign_eth = sign_tx['signature']
sign_hex = sign_eth.hex()[2:]

# Output the hex representation.
print(sign_hex)
