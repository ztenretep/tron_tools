#!/usr/bin/ruby

# Import required modules.
require 'uri'
require 'net/http'
require 'json'
require 'awesome_print'

# Initialise the service url.
url = URI('https://api.trongrid.io/wallet/listwitnesses')

# Perform the GET method.
request = Net::HTTP.get(url)

# Parse json data.
parsed = JSON.parse(request)

# Print formated json data to screen.
ap(parsed)
