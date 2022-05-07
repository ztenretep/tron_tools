#!/usr/bin/python3
"""Get account resource.
"""
# pylint: disable=invalid-name
# pylint: disable=no-member

# Import the standard Python module.
import json

# Import Python modules
from tronapi import Tron

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
account_resource = tron.trx.get_account_resource()

# Create JSON string.
account_resource = json.dumps(account_resource, indent=4)

# Print result to screen.
print(account_resource)
