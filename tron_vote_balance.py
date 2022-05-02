#!/usr/bin/python3
"""Vote for a Tron Super Representative.

If e.g. 100 Tron are frozen, then the corresponding votes are 100.
Number of votes is in this case also 100.

Private key as well as public key are defined via class attributes.

Super Representatives can be found at https://tronscan.org/. Signed
in it can be checked if staking as well as voting is working.
"""

# Import the Python module.
from tronapi import Tron

# Set public key.
public_key = '<public_key>'

# Set private key.
private_key = '<private_key>'

# Set the Super Representative.
SR = "<superrepresentive>"

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron().
tron.private_key = private_key

# Assign public key to Tron().
tron.default_address = source

# Set number of votes. type int.
nov = '<number_of_votes>'

# Vote on number of votes.
vote = tron.transaction_builder.vote([(SR, nov)], public_key)

# In tronapi a method for sign and broadcast for vote is missing.
vote = tron.trx.sign(vote)
vote = tron.trx.broadcast(vote)

# Print response.
print(vote)
