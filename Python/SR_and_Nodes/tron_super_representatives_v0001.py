#!/usr/bin/python3

# Import Python modules.
import json
from tronapi import Tron

# Instantiate Tron()
tron = Tron()

# Get list of Super Representatives.
sr_list = tron.trx.list_super_representatives()

# Convert list to str.
sr_str = json.dumps(sr, indent=4)

# Print JSON data to screen.
print(sr_str)
