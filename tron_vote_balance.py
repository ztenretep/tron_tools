#!/usr/bin/python3
"""Vote for Tron Superrepresentive for staking.

Private key as well as public key of sender are defined via class attributes. Receiver 
and amount are method arguments.
"""

# Import the Python module.
from tronapi import Tron

# Set address (public key) to send Tron from.
source = '<public_key>'

# Set private key of address to send Tron from.
private_key = '<private_key>'

# Set the Superrepresentive.
SR = "<superrepresentive>"

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = source

# Set number of votes. type int.
nv = '<number_of_votes>'

# Vote on number of votes.
vote = tron.transaction_builder.vote([(SR, nv)], source)

# In tronapi is a method for sign and broadcast for vote missing.
vote = tron.trx.sign(vote)
vote = tron.trx.broadcast(vote)

# Print response.
print(vote)
