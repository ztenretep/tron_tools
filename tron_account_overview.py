#!/usr/bin/python3
"""Tron account overview.

Limitation: Output is limited to one Super Representative.

Use your own data for:
    <private_key>  and
    <public key>
"""

# Import Python modules
import os
from datetime import datetime
from tronapi import Tron

# Set private key.
private_key = '<private_key>'

# Set public key.
public_key = '<public key>'

# Define header.
HEADER = """
==============================================================
TRON (TRX) ACCOUNT OVERVIEW
==============================================================
""".strip()

# Get current date.
now = datetime.today()

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# Get account info dictionary.
account_info_dict = tron.trx.get_account()

# Clear screen.
os.system('clear')

# Print header
print(HEADER)

# Print timestamp.
dt = now.strftime("%Y-%m-%d %H:%M:%S")
print("Timestamp: ", dt, "\n")

# Extract default address from dict.
default_address = account_info_dict["address"]
default_address = tron.address.from_hex(default_address).decode("utf-8")

# Extract balance from dict.
balance = account_info_dict["balance"]/1000000

# Extract votes from dict.
votes = account_info_dict["votes"][0]["vote_count"]

# Extract Super Representative from dict.
vote_address = account_info_dict["votes"][0]["vote_address"]
vote_address = tron.address.from_hex(vote_address).decode("utf-8")

# Extract frozen bandwidth.
frozen = int(account_info_dict["frozen"][0]["frozen_balance"]/1000000)
timestamp_frozen = int(account_info_dict["frozen"][0]["expire_time"]/1000)
timestamp_frozen = datetime.fromtimestamp(timestamp_frozen)

# Extract frozen energy.
resource = int(account_info_dict["account_resource"]["frozen_balance_for_energy"]["frozen_balance"]/1000000)
timestamp_energy = int(account_info_dict["account_resource"]["frozen_balance_for_energy"]["expire_time"]/1000)
timestamp_energy = datetime.fromtimestamp(timestamp_energy)

# Calculate some values.
stakes = frozen + resource
available_votes = stakes - votes
balance_total = balance + stakes

# Set format string.
fmt_str = "{0:28s}{1}"

# Print everything to screen.
print(fmt_str.format("Account:", str(default_address)))
print(fmt_str.format("Total Balance:", str(balance_total)))
print(fmt_str.format("Available Balance:", str(balance)))
print(fmt_str.format("Staked Balance:", str(stakes)))
print(fmt_str.format("  Frozen Bandwidth:", str(frozen)))
print(fmt_str.format("    \u21B3 Expire Time:", str(timestamp_frozen)))
print(fmt_str.format("  Frozen Energy:", str(resource)))
print(fmt_str.format("    \u21B3 Expire Time:", str(timestamp_energy)))
print(fmt_str.format("  \u2192 Super Representative:", str(vote_address)))
print(fmt_str.format("Cast Votes:", str(votes)))
print(fmt_str.format("Available Votes:", str(available_votes)))

# Print farewell message.
print("\nHave a nice day. Bye!")
