#!/usr/bin/ruby

require 'uri'
require 'net/http'
require 'openssl'

url = URI('https://api.trongrid.io/wallet/listwitnesses')

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)

response = http.request(request)
puts response.read_body
