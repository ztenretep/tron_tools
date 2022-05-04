#!/usr/bin/python3
"""Vote for a Tron Super Representative.

If e.g. 100 Tron are frozen, then the corresponding votes are 100.
Number of votes is in this case also 100.

One has to count the number of votes. If one stake another 50 Tron,
the new number of votes for the SR increases to 150.

Private key as well as public key are defined via class attributes.

Super Representatives can be found at https://tronscan.org/. Signed
in it can be checked if staking as well as voting is working.
"""
# pylint: disable=invalid-name
# pylint: disable=unused-variable
# pylint: disable=useless-return
# pylint: disable=unused-argument
# pylint: disable=redefined-outer-name
# pylint: disable=too-many-locals

# Import the Python module.
import json
import sys
import signal
import os
import os.path
from tronapi import Tron

HEREDOC = """
# Configuration file:
#
# Make sure, that each line starts with the keyword followed by the equal
# sign which is surrounded by spaces and that the values are surrounded by
# double quotes.
#
# Allowed key words:
#     public_key, private_key,
#     amount, duration, resource,
#     number_of_counts, super_representative
#
# Example: key = "value"
#
# Set the value of resource to:
#     ENERGY
#     BANDWIDTH
#
# Empty lines and lines that starts with a hashmark are ignored.
#
# Account section.
public_key = "TDmEMMWXDadewvnQm6BXiqnacBmXydMcCv"
private_key = "6875AB44318B0E9E0AA38A6CB7293B6412921EBB51FCD8521F092E758CF9625B"
#
# Freezing section.
amount = "5"
duration = "3"
resource = "ENERGY"
# Voting section.
number_of_counts = "5"
super_representative = "TZEvFv7KLX6dwHixVM4UdcGd1XLwjx5pZq"
""".strip()

# Set the configuration filename.
FN = "account.conf"

# Initialise the data dict.
DATA = {"public_key": None, "private_key": None,
        "amount": None, "duration": None, "resource": None,
        "number_of_counts": None, "super_representative": None}

# Check if file exists.
if not os.path.isfile(FN):
    with open(FN, "w") as fo:
        fo.write(HEREDOC)

# -------------------------
# Define the signal handler
# -------------------------
def signal_handler(signum, frame):
    """Define the signal handler."""
    # Print message to screen.
    print('You pressed Ctrl+C!')
    # Exit script.
    sys.exit(0)

# ====================
# Function read_data()
# ====================
def read_data(fn, data):
    """Read data from file."""
    # Read data from file.
    with open(fn, "r") as fo:
        for index, line in enumerate(fo):
            for key in data:
                if line.startswith(key):
                    data[key] = line.split("=")[1].strip().replace('"', '')
    # Return data.
    return data

# =====================
# Main script function.
# =====================
def main(tron, fn, data):
    """Main script function."""
    # Clear screen.
    os.system('clear')
    # Read configuration file.
    user_data = read_data(fn, data)
    # Set the constants.
    public_key = str(user_data["public_key"])
    private_key = str(user_data["private_key"])
    amount = int(user_data["amount"])
    duration = int(user_data["duration"])
    resource = str(user_data["resource"])
    number_of_counts = int(user_data["number_of_counts"])
    super_representative = str(user_data["super_representative"])
    # Print the constants to screen.
    fmt_str = "{0:21s} {1}"
    for key in user_data:
        new_key = "{0}:".format(key.capitalize().replace('_', ' '))
        print(fmt_str.format(new_key, user_data[key]))
    # Ask user, if everything is okay.
    input("\nCheck if the data is correct. Press ENTER to process. Press CTRL+C to dismiss.")
    # Assign private key to Tron() here.
    tron.private_key = private_key
    # Assign public key to Tron() here.
    tron.default_address = public_key
    # Vote with the number of votes on the Super Representative.
    vote_tx = tron.transaction_builder.vote([(super_representative, number_of_counts)])
    # In tronapi a method for sign and broadcast for vote is missing.
    vote = tron.trx.sign_and_broadcast(vote_tx)
    # Convert list to str.
    vote_str = json.dumps(vote, indent=2)
    # Print response.
    print("\nResponse from blockchain:\n")
    print(vote_str)
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
