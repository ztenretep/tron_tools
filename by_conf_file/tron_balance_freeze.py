#!/usr/bin/python3
"""Freeze Tron for staking.

Function freeze_balance of class trx (Trx -> mapped to trx) is
calling function freeze_balance of class transaction_builder
(TransactionBuilder -> mapped to transaction_builder).

Private key as well as public key of sender are defined via
class attributes.
"""

# Import the Python module.
from tronapi import Tron
import json
import os
import sys
import os.path
import signal

HEREDOC="""
# Configuration file:
#
# Make sure, that each line starts with the keyword followed by the equal
# sign which is surrounded by spaces and that the values are surrounded by
# double quotes.
#
# Set the value of resource to:
#     ENERGY
#     BANDWIDTH
#
# Empty lines and lines that starts with a hashmark are ignored.
public_key = "TDmEMMWXDadewvnQm6BXiqnacBmXydMcCv"
private_key = "6875AB44318B0E9E0AA38A6CB7293B6412921EBB51FCD8521F092E758CF9625B"
amount = "5"
duration = "3"
resource = "ENERGY"
""".strip()

# Set the configuration filename.
FN = "account.conf"

# INitialise data dict.
DATA = {"public_key": None, "private_key": None,
        "amount": None, "duration": None, "resource": None}

# Check if file exists.
if not os.path.isfile(FN):
    with open(FN, "w") as fo:
        fo.write(HEREDOC)

def read_data(fn, data):
    # Read data from file.
    with open(fn, "r") as fo:
        for index, line in enumerate(fo):
            for key in data:
                if line.startswith(key):
                    data[key] = line.split("=")[1].strip().replace('"', '')
    return data

# -------------------------
# Define the signal handler
# -------------------------
def signal_handler(signum, frame):
    """Define the signal handler."""
    # Print message to screen.
    print('You pressed Ctrl+C!')
    # Exit script.
    sys.exit(0)

# =====================
# Main script function.
# =====================
def main(tron, fn, data):
    # Clear screen.
    os.system('clear')
    # Read configuration file.
    filled_in_data = read_data(fn, data)
    # Set the constants.
    public_key = str(filled_in_data["public_key"])
    private_key = str(data["private_key"])
    amount = int(filled_in_data["amount"])
    duration = int(filled_in_data["duration"])
    resource = str(filled_in_data["resource"])
    # Print the constants to screen.
    print("{:14s}{}".format("Public key:", public_key))
    print("{:14s}{}".format("Private key:", private_key))
    print("{:14s}{}".format("Amount:", amount))
    print("{:14s}{}".format("Duration:", duration))
    print("{:14s}{}".format("Resource:", resource))
    # Ask user, if everything is okay.
    input("\nCheck if the data is correct. Press ENTER to process. Press CTRL+C to dismiss.")
    # Assign private key to Tron() here.
    tron.private_key = private_key
    # Assign public key to Tron() here.
    tron.default_address = public_key
    # Freeze the amount of Tron.
    freeze = tron.trx.freeze_balance(amount, duration, resource)
    # Convert list to str.
    freeze_str = json.dumps(freeze, indent=2)
    # Print response.
    print("\n", freeze_str)
    # Return None.
    return None

# Execute script as program or as module.
if __name__ == "__main__":
    # register the signal handler.
    signal.signal(signal.SIGINT, signal_handler)
    # Create a new instance of Tron().
    tron = Tron()
    # Call the main function.
    main(tron, FN, DATA)
