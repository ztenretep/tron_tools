#!/usr/bin/python3
"""Send Tron from source to destination.

Function send_transaction of class trx (Trx -> mapped to trx) is calling function
send_transaction of class transaction_builder (TransactionBuilder -> mapped to 
transaction_builder).

Signing and broadcasting is done from within send_transaction (TransactionBuilder).

Private key as well as public key of sender are defined via class attributes. Receiver 
and amount are method arguments.
"""

# Import the Python module.
from tronapi import Tron

# Set address (public key) to send Tron to.
destination = '<destination_address>'

# Set address (public key) to send Tron from.
source = '<source_address>'

# Set private key of address to send Tron from.
private_key = '<private_key>'

# Set TRX amount to send.
amount = 1.0 # Must be of type float!

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = source

# Prepare transaction.
send = tron.trx.send_transaction(destination, amount)

# Print response.
print(send)
