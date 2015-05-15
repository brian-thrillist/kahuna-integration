#!/usr/bin/env ruby

require 'net/http'
require 'pp'
require 'json'
require './flatten'

url = URI.parse("https://tap-nexus.appspot.com/api/kahunalogs?env=s")

headers =  {
  "Server certificate" => "*.appspot.com;Google Internet Authority G2;GeoTrust Global CA"
}

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
# http.set_debug_output STDOUT # for debugging

request = Net::HTTP::Post.new(url, headers)
request.basic_auth("<secret>", "<password>")

response = http.request request, '{"number_of_records" : 10, "categories_to_return" : [ "push" ], "timestamp" : "05/06/2015" }'

hash = JSON.parse(response.body)
HashToCSV::convert(hash['push'], '/tmp/kahuna_data.csv')

