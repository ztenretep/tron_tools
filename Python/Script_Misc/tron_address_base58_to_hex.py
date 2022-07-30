#!/usr/bin/python3

# Import the Python module.
from tronapi import Tron

# Create an instance of Tron.
tron=Tron()

# Set Base58 address
base58_addr = 'TLrj4MzaitvA2jRH7a8G4f8JtqhTsTg4sy'

# Base 58 to hex.
addr_hex = tron.address.to_hex(base58_addr)
print(addr_hex)
