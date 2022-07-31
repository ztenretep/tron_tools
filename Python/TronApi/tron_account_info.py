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

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# Get account info.
account_info = tron.trx.get_account()

# Create JSON string.
account_info = json.dumps(account_info, indent=4)

# Print result to screen.
print(account_info)
