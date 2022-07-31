#!/usr/bin/python3
"""Create a new Tron account.
"""

# Import the Python module.
from tronapi import Tron

# Create a new instance of Tron().
tron = Tron()

# Create an account object.
account = tron.create_account

# Create a private key.
private_key = account.private_key

# Create a public key.
public_key = account.public_key

# Create a Tron address.
tron_address = account.address.base58

# Print result to screen.
print("Public Key: ", public_key)
print("Private Key: ", private_key)
print("Tron Address: ", tron_address)
