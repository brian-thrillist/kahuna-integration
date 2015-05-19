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

params = {
  "number_of_records"     => 1000,
  "categories_to_return"  => [ "push" ],
  "timestamp"             => "05/06/2015"
}

more_records = true
mode = 'write'

while more_records
  request = Net::HTTP::Post.new(url, headers)
  request.basic_auth("<secret>", "<password>")

  response = http.request(request, params.to_json)
  response_data = JSON.parse(response.body)
  HashToCSV::convert(response_data['push'], '/tmp/kahuna_data.csv', mode: mode)

  mode = :append
  params.delete "timestamp"
  more_records = !!response_data['more_records']
  params['cursor'] = response_data['cursor']
end

