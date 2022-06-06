#!/usr/bin/python3
'''Get list of TRC10 token.

Ref.: https://github.com/tronscan/tronscan-frontend/blob/dev2019/document/api.md
'''
# pylint: disable=invalid-name

# Import the Python Modules.
import json
import requests

# Set API URL.
API_URL = "https://apilist.tronscan.org"

# Set TRON REQUEST.
TRON_REQUEST = "/api/token"

# Set PARAMS of Tron request seperated by a &.
REQUEST_PARAMS = "sort=-name&limit=20&start=0&totalAll=1&status=ico"

# Assemble URL.
URL = API_URL + TRON_REQUEST + "?" + REQUEST_PARAMS

# Get data from request.
data = requests.get(URL)

# Make JSON data from request.
res = data.json()

# Create formated string.
res = json.dumps(res, indent=4)

# Print result to screen.
print(res)
