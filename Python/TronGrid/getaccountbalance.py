#!/usr/bin/python3

import requests
import json

address = "<address_in_hex>"

url = "https://api.trongrid.io/walletsolidity/getaccount"

payload = {
    "address": address
}

headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
}

response = requests.post(url, json=payload, headers=headers)

response = response.text

response = json.loads(response)

response = json.dumps(response, indent=2)

print(response)
