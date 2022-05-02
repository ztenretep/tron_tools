#!/usr/bin/python3
"""Send Tron from source to destination.

This code has to be tested. It is written based on the source code of tronapi.

Function freeze_balance of class trx (Trx -> mapped to trx) is calling function
freeze_balance of class transaction_builder (TransactionBuilder -> mapped to 
transaction_builder).

Signing and broadcasting is done from within send_transaction (TransactionBuilder).

Private key as well as public key of sender are defined via class attributes. Receiver 
and amount are method arguments.

Proof of concept comming soon.
"""

# Import the Python module.
from tronapi import Tron

# Set address (public key) to send Tron to.
destination = '<destination_address>'

# Set address (public key) to send Tron from.
source = '<source_address>'

# Set private key of address to send Tron from.
private_key = '<private_key>'

# Set TRX amount to freeze.
amount = 1.0

duration = 3

resource = 'BANDWIDTH'
resource = 'ENERGY'

account = None

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = source

freeze = tron.trx.freeze_balance(amount, duration, 'BANDWIDTH', account)

# Print response.
print(freeze)
