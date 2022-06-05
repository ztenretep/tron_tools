#!/usr/bin/python3

# Import Python modules
from tronapi import Tron
import json

# Instantiate Tron.
tron = Tron()

# Set private key.
private_key = '<private_key>'

# Set public key.
public_key = '<public_key>'

# Initialise variable.
votes = 0

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# Get account info.
account_info_tx = tron.trx.get_account()

# Get votes list.
votes_list = account_info_tx["votes"]

# Loop over votes list.
votes = sum([int(lele["vote_count"]) for lele in votes_list])

# Print result to screen.
print(votes)
