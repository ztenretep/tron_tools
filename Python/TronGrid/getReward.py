#!/usr/bin/python3
"""Claimable Tron rewards.

Exchange ADDRESS with the address for which the rewards should be displayed.
"""
# pylint: disable=invalid-name

# Import Python modules
import os
from datetime import datetime
import requests

# Set public key.
ADDRESS = "<address>"

# Define header.
HEADER = """
==============================
CLAIMABLE TRON (TRX) REWARDS
==============================
""".strip()

# Get current date.
now = datetime.today()

# Clear screen.
os.system('clear')

# Print header
print(HEADER)

# Print timestamp.
dt = now.strftime("%Y-%m-%d %H:%M:%S")
print("Timestamp:", dt, "\n")

# Set constant SUN.
SUN = 1000000

# Set url.
URL = "https://api.trongrid.io/walletsolidity/getReward"

# Initialise the payload.
PAYLOAD = {
    "address": ADDRESS,
    "visible": True
}

# Initialise the headers.
HEADERS = {
    "Accept": "application/json",
    "Content-Type": "application/json"
}

# Get the response from RPC server.
response = requests.post(URL, json=PAYLOAD, headers=HEADERS)

# Create dictionary from the response.
response = response.json()

# Calculate reward.
reward = response["reward"] / SUN

# Print reward.
print("Claimable rewards:", reward, "TRX")
