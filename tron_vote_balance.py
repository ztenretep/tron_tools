#!/usr/bin/python3
"""Vote for a Tron Super Representative.

If e.g. 100 Tron are frozen, then the corresponding votes are 100.
Number of votes is in this case also 100.

One has to count the number of votes. If one stake another 50 Tron,
the new number of votes for the SR increases to 150.

Private key as well as public key are defined via class attributes.

Super Representatives can be found at https://tronscan.org/. Signed
in it can be checked if staking as well as voting is working.

To be chnaged by the user:
    '<public_key>'           : str
    '<private_key>'          : str
    '<super_representative>' : str
    '<number_of_votes>'      : int 
"""

# Import the standard Python module.
import json

# Import the third party Python module.
from tronapi import Tron

# Set the public key.
public_key = '<public_key>'

# Set the private key.
private_key = '<private_key>'

# Set the Super Representative.
SR = '<super_representative>'

# Set the number of votes. Number of votes must be of type int.
nov = '<number_of_votes>'

# Create a new instance of class Tron().
tron = Tron()

# Assign private key to an attribute of new instance tron.
tron.private_key = private_key

# Assign public key to an attribute of new instance tron.
tron.default_address = public_key

# Vote with the number of votes on the Super.
vote_tx = tron.transaction_builder.vote([(SR, nov)], public_key)

# In tronapi a method for sign and broadcast for vote is missing.
vote = tron.trx.sign_and_broadcast(vote_tx)

# Convert list to str.
vote_str = json.dumps(vote, indent=4)

# Print response.
print(vote_str)
