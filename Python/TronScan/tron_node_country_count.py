#!/usr/bin/python3
'''Count nodes by country.

Ref.: https://github.com/tronscan/tronscan-frontend/blob/master/document/api.md
'''
# pylint: disable=invalid-name

# Import the Pythons modules.
import requests

# Set the API URL.
API_URL = "https://apilist.tronscan.org/api/nodemap"

# Get the response from the request.
response = requests.get(API_URL)

# Create dictionary from response.
response_json = response.json()

# Create json data.
response_data = response_json["data"]

# Initialise list.
country_list = []

# Loop over the dict.
for c in response_data:
    country = c["country"]
    if not country in country_list:
        country_list.append(country)

# Remove empty elements from list.
country_list = [i for i in country_list if i]

# Sort list.
country_list.sort()

# Set total.
total = 0

# Count countries.
for i in country_list:
    count = 0
    for c in response_data:
        country = c["country"]
        if i == country:
            count += 1
    print("{0:24s}{1}".format(i, count))
    total += count

# Print sum to screen.
print("{0:24s}{1}".format("Total Nodes", total))
