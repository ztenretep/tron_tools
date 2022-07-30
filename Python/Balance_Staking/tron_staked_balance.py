#!/usr/bin/python3
'''Get staked TRON.'''

# Import the third party Python module.
from tronapi import Tron

# Set value of sun.
SUN = 1000000

# Create a new instance of class Tron().
tron = Tron()

# Set the private key.
PRIVATE_KEY = "<private_key>"

# Set the public key.
PUBLIC_KEY = "<public_key>"

# =====================
# Function get_staked()
# =====================
def get_staked(trx_obj):
    '''Get staked Tron.'''
    # Set local constants.
    key0 = "frozen"
    key1 = "frozen_balance"
    key2 = "frozen_balance_for_energy"
    key3 = "account_resource"
    # Get account info dictionary.
    account_info_dict = trx_obj.trx.get_account()
    # Get raw data from dict.
    frozen_raw = account_info_dict[key0][0][key1]
    resource_raw = account_info_dict[key3][key2][key1]
    # Calculate values from raw data.
    frozen = int(frozen_raw/SUN)
    resource = int(resource_raw/SUN)
    # Calculate staked Tron.
    staked = frozen + resource
    # Return staked.
    return staked

# ====================
# Main script function
# ====================
def main(trx_obj, private_key, public_key):
    '''Main script function.'''
    # Assign private key to an attribute of new instance tron.
    trx_obj.private_key = private_key
    # Assign public key to an attribute of new instance tron.
    trx_obj.default_address = public_key
    # Try to get the staked balance.
    try:
        # Print the staked balance to screen.
        staked = get_staked(trx_obj)
        print(staked)
    except Exception as err:
        # Print an error message.
        print("An unknown ERROR occured:", str(err))

# Execute as program as well as module.
if __name__ == "__main__":
    # Call the main function.
    main(tron, PRIVATE_KEY, PUBLIC_KEY)
