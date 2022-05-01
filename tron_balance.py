#!/usr/bin/python3

# Import the Python modules.
from tronapi import Tron

# Set the Tron address.
TRON_ADDRESS="TLrj4MzaitvA2jRH7a8G4f8JtqhTsTg4sy"

# Instantiate Tron.
tron = Tron()

# Get the balance from the network.
balance = tron.trx.get_balance(TRON_ADDRESS)

# Print the balance to the screen.
print(int(balance)/1000000)

