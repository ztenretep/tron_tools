#!/usr/bin/python3
"""Claim Tron block rewards.

The private key is defined via a class attribute. The public key is calculated
from the private key.
"""
# pylint: disable=invalid-name
# pylint: disable=broad-except
# pylint: disable=no-member

# Import the Python modules.
import json
import base58
import datetime
from tronapi import Tron
from eth_keys import KeyAPI

# Set private key of address to send Tron from.
private_key = '<private_key>'

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# ==================
# Function pub_key()
# ==================
def pub_key(priv_key):
    '''Public key.'''
    # Create a byte string.
    raw_key = bytes.fromhex(priv_key)
    # Create a key object.
    key = KeyAPI.PrivateKey(raw_key)
    # Create the public key in raw format.
    public_key_raw = key.public_key
    # Create the public key in hex format.
    public_key_hex = ('41' + public_key_raw.to_address()[2:]).upper()
    # Create a Base58 address.
    base58_addr = base58.b58encode_check(bytes.fromhex(public_key_hex)).decode()
    # Return Base58 address.
    return base58_addr

# ======================
# Function get_numbers()
# ======================
def get_numbers(txt, seps):
    '''Split a string and extract all numbers.'''
    # Set the main separator.
    main_sep = seps[0]
    # Set the rest separators.
    rest_seps = seps[1:]
    # Loop over the remaining separators.
    for sep in rest_seps:
        # Replace the current separator with the main separator.
        txt = txt.replace(sep, main_sep)
    # Extract the numbers from the text string.
    result = [i.strip() for i in txt.split(main_sep) if i.isdigit()]
    # Return the result.
    return result

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Try to get the Tron block rewards.
    try:
        # Determine the public key.
        public_key = pub_key(private_key)
        # Build transaction for withdrawing block rewards.
        withdraw_tx = tron.transaction_builder.withdraw_block_rewards(public_key)
        # In trx is no method for withdraw_block_rewards.
        withdraw_tx = tron.trx.sign_and_broadcast(withdraw_tx)
        # Get JSON data.
        withdraw = json.dumps(withdraw_tx, indent=2)
        # Print response.
        print(withdraw)
    except ValueError as err:
        # Convert err to string.
        err_str = str(err)
        # Get numbers from string.
        nums = get_numbers(err_str, (' ', ','))
        # Check if 24 is in list.
        if nums[1] == "24":
            # Get date and time string.
            dt = int(nums[0]) / 1000
            dt = datetime.datetime.fromtimestamp(dt)
            # Print error string to screen.
            msg_str = "{0}{1}{2}".format("The last withdraw time is ",
                                         dt.strftime('%Y-%m-%d %H:%M:%S'),
                                         ", less than 24 hours")
            print(msg_str)
        else:
            # Print the error string to screen.
            print(str(err))
    except Exception as err:
        # Print the error string to screen.
        print(str(err))

# Execute script as program or as module.
if __name__ == "__main__":
    # Call main script function.
    main()
