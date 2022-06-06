#!/usr/bin/python3
'''Get number of votes.'''
# pylint: disable=invalid-name
# pylint: disable=no-member

# Import the Python modules.
import sys
from tronapi import Tron

# Instantiate Tron.
tron = Tron()

# Set private key.
private_key = "<private_key>"

# Set public key.
public_key = "<public_key>"

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# Get account info.
account_info = tron.trx.get_account()

# Check if dict with account info is empty.
if not account_info:
   # Print 0 to screen.
   print("0")
   # Exit script without error.
   sys.exit(0)

# Get list of votes.
votes_list = account_info["votes"]

# Get number of votes.
votes = sum([n["vote_count"] for n in votes_list])

# Print votes to screen.
print(votes)
