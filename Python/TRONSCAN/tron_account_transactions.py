#!/usr/bin/python3
'''List the Tron transaction to a given account.

The Tronscan API provides data for the so-called Tronscan Frontend.

@request:
  /api/account/list

@params:
  sort: define the sequence of the returned records
  count: total number of records 
  limit: page size for pagination
  start: query index for pagination
  count: total number of records
  start_timestamp: query start date range
  end_timestamp: query end date range
  address: Tron account address

Ref.: https://github.com/tronscan/tronscan-frontend/blob/master/document/api.md

Exchange <public_key> with the public key of the account the transaction should
be requested.
'''
# pylint: disable=line-too-long
# pylint: disable=invalid-name

# Import the Pythons modules.
import json
import requests

# Set the public key.
PUBLIC_KEY = "<public_key>"

# Set the number of transactions.
LIMIT = 1

# Set the params.
param_limit = str(LIMIT)
param_address = str(PUBLIC_KEY)

# Set the API URL.
API_URL = "https://apilist.tronscan.org/api/transaction?sort=-timestamp&count=true&limit=" \
          + param_limit + "&start=0&address=" + param_address

# Get the response from the request.
response = requests.get(API_URL)

# Get the JSON dict from the response.
response_json = response.json()

# Get the response as formated string.
response_str = json.dumps(response_json, indent=4)

# Print the response string to screen.
print(response_str)
