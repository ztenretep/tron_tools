#!/usr/bin/python3

# Import the Python module.
from tronapi import Tron

# Create an instance of Tron.
tron=Tron()

# Set hex address.
hex_addr = '41776F8FEAD2E1E8C256A85957B37A91BD90AB5EFE'

# Hex to Base58.
addr_base58 = tron.address.from_hex(hex_addr).decode("utf-8")
print(addr_base58)
