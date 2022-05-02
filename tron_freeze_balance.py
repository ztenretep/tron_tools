#!/usr/bin/python3
"""Freeze Tron for staking.

Function freeze_balance of class trx (Trx -> mapped to trx) is calling function
freeze_balance of class transaction_builder (TransactionBuilder -> mapped to 
transaction_builder).

Private key as well as public key of sender are defined via class attributes. Receiver 
and amount are method arguments.
"""

# Import the Python module.
from tronapi import Tron

# Set address (public key) to send Tron from.
source = '<source_address>'

# Set private key of address to send Tron from.
private_key = '<private_key>'

# Set TRX amount to freeze. Amount is of type int.
amount = 1

# Set duration for freezing. duration is of type int.
duration = 3

# Set what to freeze.
#resource = 'BANDWIDTH'
resource = 'ENERGY'

# Set account for the moment to None.
account = None

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = source

# Freeze the amount of money.
freeze = tron.trx.freeze_balance(amount, duration, 'BANDWIDTH', account)

# Print response.
print(freeze)
