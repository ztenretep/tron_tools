#!/usr/bin/python3

# Import the standard Python module.
import os
from datetime import datetime

# Import Python modules
from tronapi import Tron

# Instantiate Tron.
tron = Tron()

# Set private key.
private_key = '<private_key>'

# Set public key.
public_key = '<public_key>'

# Assign private key to Tron() here.
tron.private_key = private_key

# Assign public key to Tron() here.
tron.default_address = public_key

# Get account info.
resource = tron.trx.get_account_resource()

# Get bandwidth.
band_width = tron.trx.get_band_width()

# Clear screen.
os.system('clear')

print("===============================")
print("TRON (TRX) Resources")
print("===============================")

# Get current date.
now = datetime.today()

# Print timestamp.
dt = now.strftime("%Y-%m-%d %H:%M:%S")
print("Timestamp: ", dt, "\n")

# Analyse account info.
tronpowerused = resource["tronPowerUsed"]
tronpowerlimit = resource["tronPowerLimit"]
freenetused = resource["freeNetUsed"]
freenetlimit = resource["freeNetLimit"]
energylimit = resource["EnergyLimit"]
netlimit = resource["NetLimit"]

# Get bandwidth
bandwidth = freenetlimit + netlimit

# Set format string.
fmt_str = "{0:11s}{1} \ {2}"

# Print result to screen.
print(fmt_str.format("Bandwidth:", band_width, bandwidth))
print(fmt_str.format("Energy:", energylimit, energylimit))
print(fmt_str.format("Votes:", tronpowerused, tronpowerlimit))

# Print farewell message.
print("\nHave a nice day. Bye!")
