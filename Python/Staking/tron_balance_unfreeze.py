#!/usr/bin/python3
"""Unfreeze Tron from staking.

Resource bandwidth and energy can be unfreezed independently of each other.

Private key as well as public key are defined via class attributes. Resource
is the method argument.
"""
# pylint: disable=invalid-name
# pylint: disable=broad-except
# pylint: disable=no-member

# Import the Python modules.
import json
from tronapi import Tron

# Set public key.
public_key = "<public_key>"

# Set private key.
private_key = "<private_key>"

# Set what to freeze.
#resource = 'ENERGY'
resource = 'BANDWIDTH'

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# Try to unfreeze balance.
try:
    # Unfreeze balance.
    unfreeze_tx = tron.trx.unfreeze_balance(resource)
    # Create JSON string.
    unfreeze_json = json.dumps(unfreeze_tx, indent=2)
    # Print JSON string.
    print(unfreeze_json)
except ValueError as err:
    # Print error message.
    print("Value Error:", str(err))
except Exception as err:
    # Print error message.
    print("Unknown Error:", str(err))
