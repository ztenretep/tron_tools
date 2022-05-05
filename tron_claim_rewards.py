#!/usr/bin/python3
"""Claim Tron block rewards.

Private key as well as public key of sender are defined via class attributes. Receiver 
and amount are method arguments.
"""

# Import the Python module.
from tronapi import Tron

# Set address (public key) to send Tron from.
public_key = '<public_key>'

# Set private key of address to send Tron from.
private_key = '<private_key>'

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
# tron.default_address = public_key

# Build transaction for withdrawing block rewards.
withdraw = tron.transaction_builder.withdraw_block_rewards(public_key)

# In trx is no method for withdraw_block_rewards.
withdraw = tron.trx.sign(withdraw)
withdraw = tron.trx.broadcast(withdraw)

# Print response.
print(withdraw)
