#!/usr/bin/python3
"""Claim Tron block rewards.

Private key as well as public key of sender are defined via class attributes.
"""

# Import the Python module.
import sys
import json
import traceback
from datetime import datetime, timedelta

# Import the Python modules from PyPI.
from tronapi import Tron

# Set address (public key) to send Tron from.
public_key = '<public_key>'

# Set private key of address to send Tron from.
private_key = '<private_key>'

# Set the needed substrings.
SUBSTR1 = "The last withdraw time is "
SUBSTR2 = ", less than 24 hours"

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# ========================
# Function get_timestamp()
# ========================
def get_timestamp(err_str):
    """get timestamp from string."""
    # Set variables.
    res = ''
    sub1 = "The last withdraw time is "
    sub2 = ", less than 24 hours"
    # Get the index of the substrings.
    idx1 = str(err_str).index(sub1)
    idx2 = str(err_str).index(sub2)
    # Get the elements in between.
    for idx in range(idx1 + len(sub1), idx2):
        res = res + err_str[idx]
    # Return timestamp.
    return res

# ======================
# Function make_dt_str()
# ======================
def make_dt_str(timestamp):
    """Make date and time string."""
    # Divide integer of timestamp by 1000.
    dt_str = int(timestamp)/1000
    # Create a new date time object with offset of 24 hours.
    dt_obj = datetime.fromtimestamp(dt_str) + timedelta(hours=24)
    # Return date time string
    return str(dt_obj)

# =============
# Main function
# =============
def main(substr1, substr2):
    """Main script function."""
    # Try to claim the rewards.
    try:
        # Build transaction for withdrawing block rewards.
        withdraw_tx = tron.transaction_builder.withdraw_block_rewards()
        # Sign and broadcast transaction to Mainnet.
        withdraw_resp = tron.trx.sign_and_broadcast(withdraw_tx)
        # Create JSON string.
        withdraw_json = json.dumps(withdraw_resp, indent=2)
        # Print response.
        print(withdraw_json)
    except ValueError as err:
        # Check it its a known error.
        if substr1 in str(err) and substr2 in str(err):
            # Get timestamp from error string.
            dt_str = get_timestamp(str(err))
            # Get new timestamp from timestamp.
            new_dt_str = make_dt_str(dt_str)
            print("The claiming of rewards is possible at the earliest:", new_dt_str)
        else:
         print("Unknown ERROR occured.")
    except:
         print("Unknown ERROR occured.")
    # Return None
    return None

# Execute as program as well as module.
if __name__ == "__main__":
    # Call the main function.
    main(SUBSTR1, SUBSTR2)
