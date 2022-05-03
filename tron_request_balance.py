#!/usr/bin/python3
"""Request the Tron balance of a given Tron address from the blockchain.
"""
# pylint: disable=invalid-name
# pylint: disable=no-member

# Import the third party Python module.
from tronapi import Tron

# Set the Tron address.
TRON_ADDR = "TLrj4MzaitvA2jRH7a8G4f8JtqhTsTg4sy"

# Create an instance of class Tron.
tron = Tron()

# Get the balance in sun from the mainnet.
balance_sun = tron.trx.get_balance(TRON_ADDR)

# Convert the balance from sun to decimal.
balance_trx = tron.fromSun(balance_sun)

# Print the balance in decimal to the screen.
print(balance_trx)

