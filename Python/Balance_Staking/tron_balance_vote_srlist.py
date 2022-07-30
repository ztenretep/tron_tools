#!/usr/bin/python3
"""Vote for a list of Tron Super Representatives.

If e.g. 100 Tron are frozen, then the corresponding votes are 100.
Number of votes is in this case also 100.

One has to count the number of votes. If one stake another 50 Tron,
the new number of votes for the SR increases to 150.

Private key as well as public key are defined via class attributes.

Super Representatives can be found at https://tronscan.org/. Signed
in it can be checked if staking as well as voting is working.

To be changed by the user:
    '<public_key>'           : str
    '<private_key>'          : str
    '<super_representative>' : str
    '<number_of_votes>'      : int
"""
# pylint: disable=no-else-return
# pylint: disable=simplifiable-if-statement
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=broad-except

# Import the standard Python module.
import json

# Import the third party Python module.
from tronapi import Tron

# Set the private key.
PRIVATE_KEY = "<private_key>"

# Set the public key.
PUBLIC_KEY = "<public_key>"

# Set the Super Representative.
#DATA = [('<super_representative>', '<number_of_votes>')]
DATA = [('TJX4T7AgfkvWbNAyWTxhgXrJv6Yed6BgDx', 1),
        ('TTW663tQYJTTCtHh6DWKAfexRhPMf2DxQ1', 1),
        ('TGJBjL8wmRVyRStkghnhcVNYYgn6Yjno6X', 1),
        ('TCZvvbn4SCVyNhCAt1L8Kp1qk5rtMiKdBB', 1),
        ('TDpt9adA6QidL1B1sy3D8NC717C6L5JxFo', 1)]

# Create a new instance of class Tron().
tron = Tron()

# =====================
# Function is_integer()
# =====================
def is_integer(number):
    '''Check if number is integer.'''
    # Check if number is of type integer.
    if isinstance(number, int):
        # Return True.
        return True
    else:
        # Return False.
        return False

# =====================
# Function get_staked()
# =====================
def get_staked(tron_obj):
    '''Get staked Tron.'''
    # Set sun.
    sun = 1000000
    # Get account info dictionary.
    account_info_dict = tron_obj.trx.get_account()
    # Get raw data from dict.
    frozen_raw = account_info_dict["frozen"][0]["frozen_balance"]
    resource_raw = account_info_dict["account_resource"]["frozen_balance_for_energy"]["frozen_balance"]
    # Calculate values.
    frozen = int(frozen_raw/sun)
    resource = int(resource_raw/sun)
    # Calculate staked Tron.
    staked = frozen + resource
    # Return staked.
    return staked

# ====================
# Main script function
# ====================
def main(tron_obj, private_key, public_key, data):
    '''Main script function.'''
    # Assign private key to an attribute of new instance tron.
    tron_obj.private_key = private_key
    # Assign public key to an attribute of new instance tron.
    tron_obj.default_address = public_key
    # Try to vote for Super Representative.
    try:
        # Vote with the number of votes on the Super.
        vote_tx = tron_obj.transaction_builder.vote(data)
        # In tronapi a method for sign and broadcast for vote is missing.
        vote = tron_obj.trx.sign_and_broadcast(vote_tx)
        # Convert list to str.
        vote_str = json.dumps(vote, indent=2)
        # Print response.
        print(vote_str)
    except Exception as err:
        # Print an error message.
        print("An unknown ERROR occured:", str(err))

# Execute as program as well as module.
if __name__ == "__main__":
    # Call the main function.
    main(tron, PRIVATE_KEY, PUBLIC_KEY, DATA)
