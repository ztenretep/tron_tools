#!/usr/bin/python3

# Import the Python module.
from tronapi import Tron

# Create an instance of Tron.
tron=Tron()

# Set Base58 address
base58_addr = 'TLrj4MzaitvA2jRH7a8G4f8JtqhTsTg4sy'

# Set hex address.
hex_addr = '41776F8FEAD2E1E8C256A85957B37A91BD90AB5EFE'

# Base 58 to hex.
addr_hex = tron.address.to_hex(base58_addr)
print(addr_hex)

# Hex to Base58
addr_base58 = tron.address.from_hex(hex_addr).decode("utf-8")
print(addr_base58)
