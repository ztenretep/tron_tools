#!/usr/bin/python3
"""Tron account overview.

Use your own data for:
    <private_key>  and
    <public key>
"""

# Import Python modules
import os
import json
import requests
from datetime import datetime
from tronapi import Tron

# Set private key.
private_key = "<private_key>"

# Set public key.
public_key = "<public key>"

# Instantiate Tron.
tron = Tron()

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# Define header.
HEADER = """
==============================================================
TRON (TRX) ACCOUNT OVERVIEW
==============================================================
""".strip()

# Get current date.
NOW = datetime.today()
DT = NOW.strftime("%Y-%m-%d %H:%M:%S")

# ===================
# Function get_list()
# ===================
def get_list():
    '''Get list of Super Representatives.'''
    url = "https://api.trongrid.io/walletsolidity/listwitnesses"
    response = requests.get(url)
    response_json = response.json()
    sr_list = response_json["witnesses"]
    return sr_list

# ==================
# Function find_sr()
# ==================
def find_sr(sr_list, addr):
    '''Find addr in list.'''
    for ele in sr_list:
        sr = ele["address"]
        url = ele["url"]
        if sr == addr:
            return sr, url
    return None

# ====================
# Main script function
# ====================
def main():
    '''Main script function.'''
    # Get SR list.
    sr_list = get_list()
    # Clear screen.
    os.system('clear')
    # Print header
    print(HEADER)
    # Print timestamp.
    print("Timestamp:", DT, "\n")
    # Get account info dictionary.
    account_info_dict = tron.trx.get_account()
    # Analyse account info.
    default_address = account_info_dict["address"]
    default_address = tron.address.from_hex(default_address).decode("utf-8")
    balance = account_info_dict["balance"]/1000000
    #votes = account_info_dict["votes"][0]["vote_count"]
    vote_address = account_info_dict["votes"][0]["vote_address"]
    vote_address = tron.address.from_hex(vote_address).decode("utf-8")
    frozen = int(account_info_dict["frozen"][0]["frozen_balance"]/1000000)
    timestamp_frozen = int(account_info_dict["frozen"][0]["expire_time"]/1000)
    timestamp_frozen = datetime.fromtimestamp(timestamp_frozen)
    resource = int(account_info_dict["account_resource"]["frozen_balance_for_energy"]["frozen_balance"]/1000000)
    timestamp_energy = int(account_info_dict["account_resource"]["frozen_balance_for_energy"]["expire_time"]/1000)
    timestamp_energy = datetime.fromtimestamp(timestamp_energy)
    stakes = frozen + resource
    balance_total = balance + stakes
    # Get the number of votes from the dictionary.
    votes = account_info_dict["votes"]
    votes_sum = sum([v["vote_count"] for v in votes])
    available_votes = stakes - votes_sum
    # Calculate time until next vote cycle.
    cycle_time = tron.trx.time_until_next_vote_cycle()
    cycle_time = datetime.fromtimestamp(cycle_time)
    # Calculate claimable reward.
    response = tron.manager.request('/wallet/getReward', {
        'address': tron.address.to_hex(public_key)})
    rewards = response['reward']/1000000
    # Set format string.
    fmt_str = "{0:26s}{1}"
    fmt_str_1 = "{0:26s}{1}{2}{3}"
    # Print everything to screen.
    print(fmt_str.format("Account:", str(default_address)))
    print(fmt_str.format("Total Balance:", str(balance_total)))
    print(fmt_str.format("Available Balance:", str(balance)))
    print(fmt_str.format("Unclaimed Rewards:", str(rewards)))
    print(fmt_str.format("Staked Balance:", str(stakes)))
    print(fmt_str.format("  Frozen Bandwidth:", str(frozen)))
    print(fmt_str.format("    \u21B3 Expire Time:", str(timestamp_frozen)))
    print(fmt_str.format("  Frozen Energy:", str(resource)))
    print(fmt_str.format("    \u21B3 Expire Time:", str(timestamp_energy)))
    print(fmt_str.format("Next Vote Cycle:", str(cycle_time)))
    print(fmt_str.format("Available Votes:", str(available_votes)))
    print(fmt_str.format("Casted Votes:", str(votes_sum)))
    for i in votes:
        sr_hex = i['vote_address']
        addr_base58 = tron.address.from_hex(sr_hex).decode("utf-8")
        vc = i['vote_count']
        sr, url = find_sr(sr_list, sr_hex)
        print(fmt_str_1.format("  \u2192 Super Representative:", str(addr_base58), "  \u2192 Vote count: ", vc))
        print("    \u21B3", "SR (HEX):", sr, "URL:", url)
    # Print farewell message.
    print("\nHave a nice day. Bye!")

# Execute script as program or as module.
if __name__ == "__main__":
    # Call main function.
    main()
